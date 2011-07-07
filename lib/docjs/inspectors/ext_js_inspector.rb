require 'rkelly'
require 'find'
require_relative '../visitors/ext_js_inspection_visitor'
require_relative '../meta/file'
require_relative '../meta/project'

module DocJS
  module Inspectors
    class ExtJsInspector
      def inspect_file(path)
        parser = RKelly::Parser.new

        File.open(path) do |file|
          ast = parser.parse(file.read)

          source_file = Meta::File.new(File.basename(path), path)

          visitor = Visitors::ExtJsInspectionVisitor.new()

          ast.accept(visitor)

          source_file.modules = visitor.modules
          source_file.classes = visitor.classes
          source_file.functions = visitor.functions
          source_file
        end
      end

      def inspect_path(path)
        project = Meta::Project.new(path)
        Find.find(path) do |file|
          next if FileTest.directory? file
          project.files << inspect_file(file)
        end
        project
      end
    end
  end
end
