require 'rkelly'

parser = RKelly::Parser.new

File.open('sample/simple.js') do |file|
  ast = parser.parse(file.read)
end