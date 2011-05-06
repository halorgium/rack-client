module Rack
  module Client
    class Base
      extend Forwardable

      ASCII_ENCODING = 'ASCII-8BIT'

      def_delegator :@app, :call

      def initialize(app)
        @app = app
      end

      %w[ options get head post put delete trace connect ].each do |method|
        eval <<-RUBY, binding, __FILE__, __LINE__ + 1
          def #{method}(url, headers = {}, body = nil, &block)
            request('#{method.upcase}', url, headers, body, &block)
          end
        RUBY
      end

      def request(method, url, headers = {}, body = nil)
        if block_given?
          call(build_env(method.upcase, url, headers, body)) {|tuple| yield *tuple }
        else
          return *call(build_env(method.upcase, url, headers, body))
        end
      end

      def build_env(request_method, url,  headers = {}, body = nil)
        env = Headers.new(headers).to_env

        env.update 'REQUEST_METHOD' => request_method

        env['CONTENT_TYPE'] ||= 'application/x-www-form-urlencoded'

        uri = URI.parse(url)

        path_info = uri.path.empty? ? '/' : uri.path

        env.update 'PATH_INFO'    => path_info
        env.update 'REQUEST_URI'  => uri.to_s
        env.update 'SERVER_NAME'  => uri.host.to_s
        env.update 'SERVER_PORT'  => uri.port.to_s
        env.update 'SCRIPT_NAME'  => ''
        env.update 'QUERY_STRING' => uri.query.to_s

        input  = ensure_acceptable_input(body)
        errors = StringIO.new

        [ input, errors ].each do |io|
          io.set_encoding(ASCII_ENCODING) if io.respond_to?(:set_encoding)
        end

        env.update 'rack.input'         => input
        env.update 'rack.errors'        => errors
        env.update 'rack.url_scheme'    => uri.scheme || 'http'
        env.update 'rack.version'       => Rack::VERSION
        env.update 'rack.multithread'   => true
        env.update 'rack.multiprocess'  => true
        env.update 'rack.run_once'      => false

        env.update 'HTTPS'  => env["rack.url_scheme"] == "https" ? "on" : "off"

        env
      end

      def ensure_acceptable_input(body)
        if %w[gets each read rewind].all? {|m| body.respond_to?(m.to_sym) }
          body
        elsif body.respond_to?(:each)
          input = StringIO.new
          body.each {|chunk| input << chunk }
          input.rewind
          input
        else
          input = StringIO.new(body.to_s)
          input.rewind
          input
        end
      end
    end
  end
end
