Bundler.require_env(:test)

require File.expand_path(File.dirname(__FILE__) + "/../lib/rack/client")
require File.expand_path(File.dirname(__FILE__) + '/server_helper')

Spec::Runner.configure do |config|
  config.before(:all) do
    @server = InThreadServer.rackup(File.expand_path(File.dirname(__FILE__) + '/apps/example.org.ru'))
  end
end
