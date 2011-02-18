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

      def visit_FunctionCallNode(o)
        check_for_namespace(o)
        super
      end

      def check_for_namespace(node)
        scope = node.value.value.value if node.value.respond_to?('value') && node.value.value.respond_to?('value')
        function = node.value.accessor if node.value.respond_to?('accessor')

        if scope == 'Ext' && function == 'namespace'
          namespace = Meta::Namespace.new
          namespace.name = node.arguments.value[0].value
          namespace.comments = node.comments

          @namespaces.push(namespace)
        end
      end
    end
  end
end

