require 'rkelly'
require_relative '../meta/module'
require_relative '../meta/class'
require_relative '../meta/method'
require_relative '../meta/property'

module DocJS
  module Visitors
    class ExtJsInspectionVisitor < RKelly::Visitors::Visitor
      attr_accessor :modules,
                    :classes,
                    :functions

      def initialize()
        @modules = []
        @classes = []
        @functions = []
      end

      def node_to_path(node)
        return [node.value] if node.is_a? RKelly::Nodes::ResolveNode
        return node_to_path(node.value) + [node.accessor] if node.is_a? RKelly::Nodes::DotAccessorNode
        []
      end

      def get_comment_for_node(node)
        node.comments.first.value if node.comments.first.respond_to? :value
      end

      def visit_DotAccessorNode(node)
        if is_module_declaration?(node)
          @modules << create_module_from_node(node)
        elsif is_class_declaration?(node)
          @classes << create_class_from_node(node)
        end
      end

      def visit_FunctionDeclNode(node)
        if is_function_declaration?(node)
          @functions << create_declared_function_from_node(node)
        end
      end

      def visit_FunctionExprNode(node)
        if is_function_assignment?(node)
          @functions << create_assigned_function_from_node(node)
        end
      end

      def is_function_assignment?(node)
        return false unless node.parent.is_a? RKelly::Nodes::OpEqualNode
        true
      end

      def create_assigned_function_from_node(node)
        name = node_to_path(node.parent.left).join('.')
        comment = get_comment_for_node(node)
        Meta::Method.new(name, comment)
      end

      def is_function_declaration?(node)
        return false unless node.parent.is_a? RKelly::Nodes::SourceElementsNode
        true
      end

      def create_declared_function_from_node(node)
        comment = get_comment_for_node(node)
        Meta::Method.new(node.value, comment)
      end

      def is_module_declaration?(node)
        return false unless node.accessor == 'namespace'
        return false unless node.value.is_a? RKelly::Nodes::ResolveNode
        return false unless node.value.value == 'Ext'
        return false unless node.parent.is_a? RKelly::Nodes::FunctionCallNode
        return false unless node.parent.arguments.is_a? RKelly::Nodes::ArgumentsNode
        return false unless node.parent.arguments.value.first.is_a? RKelly::Nodes::StringNode
        true
      end

      def create_module_from_node(node)
        result = Meta::Module.new
        result.name = node.parent.arguments.value.first.value
        result.comment = get_comment_for_node(node)

        result
      end

      def is_class_declaration?(node)
        return false unless node.accessor == 'extend'
        return false unless node.value.is_a? RKelly::Nodes::ResolveNode
        return false unless node.value.value == 'Ext'
        return false unless node.parent.is_a? RKelly::Nodes::FunctionCallNode
        return false unless node.parent.arguments.value.length.between?(2,3)
        true
      end

      def create_class_from_node(node)
        extend_call = node.parent

        result = Meta::Class.new
        result.comment = get_comment_for_node(node)

        case node.parent.arguments.value.length
          when 2 then
            raise 'Type name could not be determined.' unless extend_call.parent.is_a? RKelly::Nodes::OpEqualNode

            name_node = extend_call.parent.left
            extends_node = extend_call.arguments.value[0]
            properties_node = extend_call.arguments.value[1]
          when 3 then
            name_node = extend_call.arguments.value[0]
            extends_node = extend_call.arguments.value[1]
            properties_node = extend_call.arguments.value[2]
          else
            raise 'Could not understand type declaration.'
        end

        result.name = node_to_path(name_node).join('.')
        result.extends << node_to_path(extends_node).join('.')

        properties_node.value.each do |property|
          name = property.name
          comment = get_comment_for_node(property)
          case true
            when property.value.is_a?(RKelly::Nodes::FunctionExprNode) then
              result.methods << Meta::Method.new(name, comment)
            when property.value.is_a?(RKelly::Nodes::NullNode) then
              result.properties << Meta::Property.new(name, comment, 'null', nil)
            when property.value.is_a?(RKelly::Nodes::TrueNode) then
              result.properties << Meta::Property.new(name, comment, 'boolean', true)
            when property.value.is_a?(RKelly::Nodes::FalseNode) then
              result.properties << Meta::Property.new(name, comment, 'boolean', false)
            when property.value.is_a?(RKelly::Nodes::StringNode) then
              result.properties << Meta::Property.new(name, comment, 'string', property.value.value)
            when property.value.is_a?(RKelly::Nodes::NumberNode) then
              result.properties << Meta::Property.new(name, comment, 'number', property.value.value)
            else
              result.properties << Meta::Property.new(name, comment, 'object')
          end
        end

        result
      end
    end
  end
end

