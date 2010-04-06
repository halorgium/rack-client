module Rack
  module Client
    class FollowRedirects
      include DualBand

      def initialize(app)
        @app = app
      end

      def async_call(env, &block)
        @app.call(env) do |tuple|
          response = Response.new(*tuple)

          if response.redirect?
            follow_redirect(response, env, &block)
          else
            yield response.finish
          end
        end
      end

      def sync_call(env, &block)
        response = Response.new(*@app.call(env))
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
    end
  end
end
