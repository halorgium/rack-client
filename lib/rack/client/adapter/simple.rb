module Rack
  module Client
    class Simple < Base

      def initialize(app, url = nil)
        super(app)
        @base_uri = URI.parse(url) unless url.nil?
      end

      %w[ options get head post put delete trace connect ].each do |method|
        eval <<-RUBY, binding, __FILE__, __LINE__ + 1
          def #{method}(url, body_or_params = {}, headers = {})
            body = Hash === body_or_params ? body_or_params.map {|k,v| "\#{k}=\#{v}" }.join('&') : body_or_params

            if block_given?
              super(url, headers, body) {|*tuple| yield Response.new(*tuple) }
            else
              return Response.new(*super(url, headers, body))
            end
          end
        RUBY
      end

      def build_env(request_method, url, headers = {}, body = nil)
        uri = @base_uri.nil? ? URI.parse(url) : @base_uri + url
        super(request_method, uri.to_s, headers, body)
      end
    end
  end
end
