Bundler.require_env(:test)

require File.expand_path(File.dirname(__FILE__) + "/../lib/rack/client")
require File.expand_path(File.dirname(__FILE__) + '/server_helper')
require File.expand_path(File.dirname(__FILE__) + '/handler/sync_api_spec')
require File.expand_path(File.dirname(__FILE__) + '/handler/async_api_spec')

Spec::Runner.configure do |config|
  def server
    @@server ||= InThreadServer.rackup(File.expand_path(File.dirname(__FILE__) + '/apps/example.org.ru'))
  end
end
