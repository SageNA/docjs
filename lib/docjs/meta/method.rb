module DocJS
  module Meta
    class Method
      attr_accessor :name,
                    :comment

      def initialize(name = nil, comment = nil)
        @name = name
        @comment = comment
      end
    end
  end
end
