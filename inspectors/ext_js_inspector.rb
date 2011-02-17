require 'rkelly'
require_relative '../visitors/ext_js_namespace_visitor'
require_relative '../meta/code_unit'
require_relative '../meta/namespace'

module DocJS
  module Inspectors
    class ExtJsInspector
      attr_accessor :parser

      def initialize
        @parser = RKelly::Parser.new
      end

      def inspect(path)
        File.open(path) do |file|
          ast = parser.parse(file.read)
          code_unit = Meta::CodeUnit.new

          find_namespaces(code_unit, ast)

          code_unit
        end
      end

      protected

      def find_namespaces(code_unit, ast)
        visitor = Visitors::ExtJsNamespaceVisitor.new
        ast.accept(visitor)
        visitor
      end
    end
  end
end
