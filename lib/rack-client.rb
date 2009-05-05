require 'rack'
require 'rack/test'

module RackClient
  def self.configure(&block)
    stack = Stack.new
    stack.instance_eval(&block) if block_given?
    stack
  end
end

$:.unshift File.dirname(__FILE__)

require 'rack-client/http'
require 'rack-client/stack'
require 'rack-client/auth'
require 'rack-client/follow_redirects'
