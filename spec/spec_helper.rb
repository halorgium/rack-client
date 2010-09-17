$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'rack/client'

Bundler.require(:test)

dir = File.expand_path(File.dirname(__FILE__))

#require dir + '/handler/handler_api_spec'
#require dir + '/handler/async_api_spec'

RSpec.configure do |config|
  config.color_enabled = true
  #config.filter_run :focused => true
  #config.run_all_when_everything_filtered = true

  config.before(:all) do
    configru = dir + '/spec_config.ru'
    @server = RealWeb.start_server_in_thread(configru)
    @base_url = "http://127.0.0.1:#{@server.port}"
  end
end
