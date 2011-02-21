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
  end

  class Parser
    private
    def apply_comments(ast)
      link_children(ast, *ast.value)

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

    def link_children(parent, *children)
      children.each do |child|
        child.parent = parent if child.respond_to? :parent
        link_children(child, child.value) if child.respond_to? :value
      end
    end
  end
end