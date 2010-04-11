module Rack
  module Client
    class Base
      extend Forwardable

      def_delegator :@app, :call

      def initialize(app)
        @app = app
      end

      %w[ options get head post put delete trace connect ].each do |method|
        eval <<-RUBY, binding, __FILE__, __LINE__ + 1
          def #{method}(url, headers = {}, body = nil)
            if block_given?
              call(build_env('#{method.upcase}', url, headers, body)) {|tuple| yield *tuple }
            else
              return *call(build_env('#{method.upcase}', url, headers, body))
            end
          end
        RUBY
      end

      def build_env(request_method, url,  headers = {}, body = nil)
        env = {}
        env.update 'REQUEST_METHOD' => request_method
        env.update 'CONTENT_TYPE'   => 'application/x-www-form-urlencoded'

        uri = URI.parse(url)
        env.update 'PATH_INFO'   => uri.path.empty? ? '/' : uri.path
        env.update 'REQUEST_URI' => uri.to_s
        env.update 'SERVER_NAME' => uri.host
        env.update 'SERVER_PORT' => uri.port
        env.update 'SCRIPT_NAME' => ''

        input = case body
                when nil        then StringIO.new
                when String     then StringIO.new(body)
                end

        env.update 'rack.input'       => input
        env.update 'rack.errors'      => StringIO.new
        env.update 'rack.url_scheme'  => uri.scheme

        env.update 'HTTPS'  => env["rack.url_scheme"] == "https" ? "on" : "off"

        env
      end
    end
  end
end
