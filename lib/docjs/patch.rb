require 'rkelly'

module RKelly
  module Visitors
    class EnumerableVisitor < Visitor
      def visit_DotAccessorNode(o)
        @block[o]
        super
      end
    end
  end

  module Nodes
    class Node
      attr_accessor :parent
    end

    class FunctionExprNode
      attr_reader :function_name, :function_body, :arguments
      def initialize(name, body, args = [])
        super(body)
        @function_name = name
        @function_body = body
        @arguments = args
      end
    end
  end

  class Parser
    private
    def apply_comments(ast)
      link_children(ast)

      comment_hash = Hash.new

      @comments.each do |comment|
        next unless comment.line
        for_line = comment.line + comment.value.count("\n") + 1

        comment_hash[for_line] = comment
      end

      (ast || []).each do |node|
        node.comments << comment_hash[node.line] if comment_hash[node.line]
      end

      ast
    end

    def link_children(node)
      return unless node.is_a? RKelly::Nodes::Node
      (node.value.is_a?(Array) ? node.value : [node.value]).each do |child|
        child.parent = node if child.respond_to? :parent
        link_children(child) if child.respond_to? :value
      end
    end
  end
end