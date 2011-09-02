$:.unshift '../lib' # force use of local rkelly

require_relative '../lib/docjs'

inspector = DocJS::Inspectors::DojoAmdInspector.new
meta = inspector.inspect_file('dojo-amd-simple.js')

print meta