module Rack
  module Client
    class FollowRedirects
      def initialize(app)
        @app = app
      end

      def call(env, &b)
        if block_given?
          async(env, &b)
        else
          sync(env)
        end
      end

      def async(env, &block)
        @app.call(env) do |tuple|
          response = parse(*tuple)

          if response.redirect?
            follow_redirect(response, env, &block)
          else
            yield response.finish
          end
        end
      end

      def sync(env, &block)
        response = parse(*@app.call(env))
        response.redirect? ? follow_redirect(response, env, &block) : response
      end

      def follow_redirect(response, env, &block)
        call(next_env(response, env), &block)
      end

      def next_env(response, env)
        env, uri = env.dup, URI.parse(response['Location'])

        env.update 'PATH_INFO'      => uri.path
        env.update 'REQUEST_METHOD' => 'GET'

        env
      end

      def parse(status, headers = {}, body = [])
        Rack::Response.new(body, status, headers)
      end
    end
  end
end
