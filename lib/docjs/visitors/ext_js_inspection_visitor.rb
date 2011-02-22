require 'rkelly'
require_relative '../meta/namespace'

module DocJS
  module Visitors
    class ExtJsInspectionVisitor < RKelly::Visitors::Visitor
      attr_accessor :code_unit,
                    :namespaces

      def initialize(code_unit)
        @code_unit = code_unit
        @namespaces = []
      end

      def visit_DotAccessorNode(node)
        if is_namespace_declaration?(node)
          @namespaces.push(create_namespace_from(node))
        end
      end

      def is_namespace_declaration?(node)
        return false if not node.accessor == 'namespace'
        return false if not node.value.is_a? RKelly::Nodes::ResolveNode
        return false if not node.value.value == 'Ext'
        return false if not node.parent.is_a? RKelly::Nodes::FunctionCallNode
        return false if not node.parent.arguments.value.first.is_a? RKelly::Nodes::StringNode
        true
      end

      def create_namespace_from(node)
        namespace = Meta::Namespace.new
        namespace.name = node.parent.arguments.value.first.value
        namespace.comment = node.comments.first.value if node.comments.first.respond_to? :value

        namespace
      end

      def is_type_declaration?(node)
        return false if not node.accessor == 'extend'
        return false if not node.value.is_a? RKelly::Nodes::ResolveNode
        return false if not node.value.value == 'Ext'
        true
      end
    end
  end
end

