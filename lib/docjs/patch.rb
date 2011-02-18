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
      link_children(ast, ast.value)

      ast_hash = Hash.new { |h,k| h[k] = [] }
      (ast || []).each do |n|
        print "line: #{n.line}, node: #{n}\n"
        ast_hash[n.line] << n if n.line
      end
      max = ast_hash.keys.sort.last
      @comments.each do |comment|
        comment.line.upto(max) do |line|
          if ast_hash.key?(line)
            ast_hash[line].each do |node|
              print "node line: #{node.line}, comment line: #{comment.line}\n"
              node.comments << comment
            end
            break
          end
        end
      end if max
      ast
    end

    def link_children(parent, *children)
      children.each do |child|
        next unless child.respond_to? :parent
        child.parent = parent
        link_children(child, child.value) if child.respond_to? :value
      end
    end
  end
end