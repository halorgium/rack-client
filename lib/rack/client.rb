unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__) + "/.."))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/.."))
end

require 'rack'
require 'rack/test'

module Rack::Client
  Rack::Test::Methods::METHODS.each do |method_name|
    instance_eval <<-RUBY
      def #{method_name}(*args, &block)
        resource.#{method_name}(*args, &block)
      end
    RUBY
  end
  
  def self.resource(&block)
    Rack::Client::Resource.new(&block)
  end
end

$:.unshift File.dirname(__FILE__)

require 'client/http'
require 'client/resource'
require 'client/auth'
require 'client/follow_redirects'
