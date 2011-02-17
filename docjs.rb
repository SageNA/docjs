require_relative 'inspectors/ext_js_inspector'

module DocJS

end

# todo: will need to manually line up comments with nodes

inspector = DocJS::Inspectors::ExtJsInspector.new
inspector.inspect('./samples/extjs-simple.js')