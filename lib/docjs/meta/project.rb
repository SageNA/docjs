module DocJS
  module Meta
    class Project
      attr_accessor :name,
                    :files

      def initialize(name = nil)
        @name = name
        @files = []
      end

      def classes
        @files.each do |file|
          file.classes.each do |cls|
            yield cls, file
          end
        end
      end

      def modules
        @files.each do |file|
          file.modules.each do |mod|
            yield mod, file
          end
        end
      end

      def functions
        @files.each do |file|
          file.functions.each do |fn|
            yield fn, file
          end
        end
      end
    end
  end
end
