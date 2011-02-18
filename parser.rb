require 'rkelly'

module DocJS
  class Parser < RKelly::Parser
    private
    def apply_comments(ast)
      ast_hash = Hash.new { |h,k| h[k] = [] }
      (ast || []).each { |n|
        next unless n.line
        ast_hash[n.line] << n
      }
      max = ast_hash.keys.sort.last
      @comments.each do |comment|
        node = nil
        comment.line.upto(max) do |line|
          print "max: #{max}, line: #{line}, comment: #{comment}\n"
          if ast_hash.key?(line)
            node = ast_hash[line].first
            break
          end
        end
        node.comments << comment if node
      end #if max
      ast
    end
  end
end
