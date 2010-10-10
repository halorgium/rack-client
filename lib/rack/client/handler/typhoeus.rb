require 'typhoeus'

module Rack
  module Client
    module Handler
      class Typhoeus
        include Rack::Client::DualBand

        def initialize(hydra = ::Typhoeus::Hydra.new)
          @hydra = hydra
        end

        def async_call(env)
          rack_request = Rack::Request.new(env)

          typhoeus_request = request_for(rack_request)

          typhoeus_request.on_complete do |response|
            yield parse(response).finish
          end

          @hydra.queue typhoeus_request
        end

        def sync_call(env)
          rack_request = Rack::Request.new(env)

          parse(process(rack_request)).finish
        end

        def parse(typhoeus_response)
          body = (typhoeus_response.body.nil? || typhoeus_response.body.empty?) ? [] : StringIO.new(typhoeus_response.body)
          Response.new(typhoeus_response.code, Headers.new(typhoeus_response.headers_hash).to_http, body)
        end

        def request_for(rack_request)
          ::Typhoeus::Request.new((rack_request.url).to_s, params_for(rack_request))
        end

        def process(rack_request)
          ::Typhoeus::Request.run((rack_request.url).to_s, params_for(rack_request))
        end

        def params_for(rack_request)
          {
            :method => rack_request.request_method.downcase.to_sym,
            :headers => Headers.from(rack_request.env).to_http,
            :params => {}
          }.merge(body_params_for(rack_request))
        end

        def body_params_for(rack_request)
          unless %w[ HEAD GET ].include? rack_request.request_method
            {:body => rack_request.body.string}
          else
            {}
          end
        end
      end
    end
  end
end
