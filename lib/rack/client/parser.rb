module Rack
  module Client
    module Parser
      autoload :YAML, 'rack/client/parser/yaml'

      def self.new(app, &b)
        Context.new(app, &b)
      end
    end
  end
end

require 'rack/client/parser/base'
require 'rack/client/parser/body_collection'
require 'rack/client/parser/context'
require 'rack/client/parser/request'
require 'rack/client/parser/response'
