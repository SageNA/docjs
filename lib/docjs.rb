require 'rkelly'
require_relative 'docjs/patch'
require_relative 'docjs/inspectors/ext_js_inspector'

module DocJS

end

inspector = DocJS::Inspectors::ExtJsInspector.new
inspector.inspect('./samples/extjs-simple.js')