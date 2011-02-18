require 'rkelly'
require_relative '../parser'
require_relative '../visitors/ext_js_inspection_visitor'
require_relative '../meta/code_unit'
require_relative '../meta/namespace'

module DocJS
  module Inspectors
    class ExtJsInspector
      def inspect(path)
        parser = Parser.new

        File.open(path) do |file|
          ast = parser.parse(file.read)

          code_unit = Meta::CodeUnit.new
          code_unit.path = path
          code_unit.name = File.basename(path)

          visitor = Visitors::ExtJsInspectionVisitor.new(code_unit)

          ast.accept(visitor)

          code_unit
        end
      end
    end
  end
end
