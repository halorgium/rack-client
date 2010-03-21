module Rack
  module Client
    class Base
      extend Forwardable

      def_delegator :@app, :call

      def initialize(app, url = '')
        @app, @base_uri = app, URI.parse(url.to_s)
      end

      def get(url, params = {}, headers = {}, body = [])
        call(build_env('GET', url, params, headers, body))
      end

      def build_env(request_method, url, params = {}, headers = {}, body = [])
        env = {}
        env.update 'REQUEST_METHOD' => request_method
        env.update 'CONTENT_TYPE'   => 'application/x-www-form-urlencoded'

        uri = @base_uri + url
        env.update 'PATH_INFO'   => uri.path
        env.update 'REQUEST_URI' => uri.path
        env.update 'SERVER_NAME' => uri.host
        env.update 'SERVER_PORT' => uri.port

        env
      end
    end
  end
end
