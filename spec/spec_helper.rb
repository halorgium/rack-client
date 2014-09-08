$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'rack/client'

Bundler.require(:test)

dir = File.expand_path(File.dirname(__FILE__))

Dir["#{dir}/shared/*.rb"].each {|shared| require shared }
Dir["#{dir}/helpers/*.rb"].each {|helper| require helper }

def mri_187?
  RUBY_VERSION == '1.8.7' && !defined?(RUBY_ENGINE)
end

RSpec.configure do |config|
  #config.filter_run :focused => true
  #config.run_all_when_everything_filtered = true
  config.include(HandlerHelper)

  config.before(:all) do
    configru = dir + '/spec_config.ru'
    $server ||= RealWeb.start_server_in_thread(configru)
    @base_url = "http://localhost:#{$server.port}"
  end
end
