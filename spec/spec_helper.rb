$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'rack/client'

require 'rubygems'
require 'spec'
require 'em-spec/rspec'

dir = File.expand_path(File.dirname(__FILE__))
require dir + '/server_helper'
require dir + '/middleware_helper'
require dir + '/handler/sync_api_spec'
require dir + '/handler/async_api_spec'

Spec::Runner.configure do |config|
  def server
    @@server ||= InThreadServer.rackup(File.expand_path(File.dirname(__FILE__) + '/apps/example.org.ru'))
  end

  def finish() end
end
