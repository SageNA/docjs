require 'rkelly'
require_relative '../meta/namespace'
require_relative '../meta/class'
require_relative '../meta/method'
require_relative '../meta/property'

module DocJS
  module Visitors
    class ExtJsInspectionVisitor < RKelly::Visitors::Visitor
      attr_accessor :namespaces,
                    :types

      def initialize()
        @namespaces = []
        @types = []
      end

      def visit_DotAccessorNode(node)
        if is_namespace_declaration?(node)
          @namespaces << create_namespace(node)
        elsif is_type_declaration?(node)
          @types << create_type(node)
        end
      end

      def accessor_to_path(node)
        return [node.value] if node.is_a? RKelly::Nodes::ResolveNode
        return accessor_to_path(node.value) + [node.accessor] if node.is_a? RKelly::Nodes::DotAccessorNode
        []
      end

      def get_node_comment(node)
        node.comments.first.value if node.comments.first.respond_to? :value
      end

      def is_namespace_declaration?(node)
        return false unless node.accessor == 'namespace'
        return false unless node.value.is_a? RKelly::Nodes::ResolveNode
        return false unless node.value.value == 'Ext'
        return false unless node.parent.is_a? RKelly::Nodes::FunctionCallNode
        return false unless node.parent.arguments.is_a? RKelly::Nodes::ArgumentsNode
        return false unless node.parent.arguments.value.first.is_a? RKelly::Nodes::StringNode
        true
      end

      def create_namespace(node)
        namespace = Meta::Namespace.new
        namespace.name = node.parent.arguments.value.first.value
        namespace.comment = get_node_comment(node)

        namespace
      end

      def is_type_declaration?(node)
        return false unless node.accessor == 'extend'
        return false unless node.value.is_a? RKelly::Nodes::ResolveNode
        return false unless node.value.value == 'Ext'
        return false unless node.parent.is_a? RKelly::Nodes::FunctionCallNode
        return false unless node.parent.arguments.value.length.between?(2,3)
        true
      end

      def create_type(node)
        extend_call = node.parent

        type = Meta::Class.new
        type.comment = get_node_comment(node)

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

        type.name = accessor_to_path(name_node).join('.')
        type.extends << accessor_to_path(extends_node).join('.')

        #BreakNode ContinueNode EmptyStatementNode FalseNode
        #NullNode NumberNode ParameterNode RegexpNode ResolveNode StringNode
        #ThisNode TrueNode
        properties_node.value.each do |property|
          name = property.name
          comment = get_node_comment(property)
          case true
            when property.value.is_a?(RKelly::Nodes::FunctionExprNode) then
              type.methods << Meta::Method.new(name, comment)
            when property.value.is_a?(RKelly::Nodes::NullNode) then
              type.properties << Meta::Property.new(name, comment, 'null', nil)
            when property.value.is_a?(RKelly::Nodes::TrueNode) then
              type.properties << Meta::Property.new(name, comment, 'boolean', true)
            when property.value.is_a?(RKelly::Nodes::FalseNode) then
              type.properties << Meta::Property.new(name, comment, 'boolean', false)
            when property.value.is_a?(RKelly::Nodes::StringNode) then
              type.properties << Meta::Property.new(name, comment, 'string', property.value.value)
            when property.value.is_a?(RKelly::Nodes::NumberNode) then
              type.properties << Meta::Property.new(name, comment, 'number', property.value.value)
            else
              type.properties << Meta::Property.new(name, comment, 'object')
          end
        end

        type
      end
    end
  end
end

