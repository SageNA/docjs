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
    end
  end
end
