require 'rkelly'
require_relative '../meta/namespace'

module DocJS
  module Visitors
    class ExtJsNamespaceVisitor < RKelly::Visitors::Visitor
      attr_accessor :namespaces

      def initialize
        @namespaces = []
      end

      def visit_FunctionCallNode(o)
        if o.value.respond_to?('accessor') && o.value.value

          function_name = o.value.accessor
          scope_name = o.value.value.value

          print "#{scope_name}::#{function_name}\n"

        end
      end
    end
  end
end

