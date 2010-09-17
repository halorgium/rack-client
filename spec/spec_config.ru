dir = File.expand_path(File.join(File.dirname(__FILE__), 'spec_apps'))

Dir["#{dir}/*.ru"].each do |configru|
  route = File.basename(configru).gsub(/\.ru$/, '')

  map "/#{route}" do
    app, params = Rack::Builder.parse_file(configru)
    run app
  end
end
