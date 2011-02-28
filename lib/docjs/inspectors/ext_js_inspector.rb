require 'rkelly'
require_relative '../visitors/ext_js_inspection_visitor'
require_relative '../meta/file'
require_relative '../meta/module'

module DocJS
  module Inspectors
    class ExtJsInspector
      def inspect(path)
        parser = RKelly::Parser.new

        File.open(path) do |file|
          ast = parser.parse(file.read)

          source_file = Meta::File.new
          source_file.path = path
          source_file.name = File.basename(path)

          visitor = Visitors::ExtJsInspectionVisitor.new()

          ast.accept(visitor)

          source_file
        end
      end
    end
  end
end
