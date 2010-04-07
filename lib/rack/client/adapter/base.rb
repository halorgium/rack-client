module Rack
  module Client
    class Base
      extend Forwardable

      def_delegator :@app, :call

      def initialize(app)
        @app = app
      end

      def delete(url,  headers = {}, body = nil)
        if block_given?
          call(build_env('DELETE', url, headers, body)) {|tuple| yield *tuple }
        else
          return *call(build_env('DELETE', url, headers, body))
        end
      end

      def get(url,  headers = {}, body = nil)
        if block_given?
          call(build_env('GET', url, headers, body)) {|tuple| yield *tuple }
        else
          return *call(build_env('GET', url, headers, body))
        end
      end

      def head(url,  headers = {}, body = nil)
        if block_given?
          call(build_env('HEAD', url, headers, body)) {|tuple| yield *tuple }
        else
          return *call(build_env('HEAD', url, headers, body))
        end
      end

      def post(url,  headers = {}, body = nil)
        if block_given?
          call(build_env('POST', url, headers, body)) {|tuple| yield *tuple }
        else
          return *call(build_env('POST', url, headers, body))
        end
      end

      def put(url,  headers = {}, body = nil)
        if block_given?
          call(build_env('PUT', url, headers, body)) {|tuple| yield *tuple }
        else
          return *call(build_env('PUT', url, headers, body))
        end
      end

      def build_env(request_method, url,  headers = {}, body = nil)
        env = {}
        env.update 'REQUEST_METHOD' => request_method
        env.update 'CONTENT_TYPE'   => 'application/x-www-form-urlencoded'

        uri = URI.parse(url)
        env.update 'PATH_INFO'   => uri.path
        env.update 'REQUEST_URI' => uri.path
        env.update 'SERVER_NAME' => uri.host
        env.update 'SERVER_PORT' => uri.port
        env.update 'SCRIPT_NAME' => ''

        input = case body
                when nil        then StringIO.new
                when String     then StringIO.new(body)
                end
        env.update 'rack.input' => input
        env.update 'rack.errors' => StringIO.new

        env
      end
    end
  end
end
