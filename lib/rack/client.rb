unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__) + "/.."))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/.."))
end

require 'rack'
require 'rack/test'

module Rack::Client
  def self.configure(&block)
    stack = Rack::Client::Stack.new
    stack.instance_eval(&block) if block_given?
    stack
  end
end

$:.unshift File.dirname(__FILE__)

require 'client/http'
require 'client/stack'
require 'client/auth'
require 'client/follow_redirects'
