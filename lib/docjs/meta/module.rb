module DocJS
  module Meta
    class Module
      attr_accessor :name,
                    :methods,
                    :properties,
                    :comment

      def initialize(name = nil, comment = nil)
        @name = name
        @comment = comment
        @methods = []
        @properties = []
      end
    end
  end
end
