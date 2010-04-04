module Rack
  module Client
    module Auth
      class Basic
        include Rack::Client::DualBand

        def initialize(app, username, password)
          @app, @username, @password = app, username, password
        end

        def sync_call(env)
          request   = Rack::Request.new(env)
          response  = parse_response(*@app.call(env))
          challenge = Basic::Challenge.new(request, response)

          if challenge.required? && (challenge.unspecified? || challenge.basic?)
            return authorized_call(env)
          end

          response.finish
        end

        def async_call(env, &b)
          @app.call(env) do |response_parts|
            request   = Rack::Request.new(env)
            response  = parse_response(*response_parts)
            challenge = Basic::Challenge.new(request, response)

            if challenge.required? && (challenge.unspecified? || challenge.basic?)
              authorized_call(env, &b)
            else
              yield response.finish
            end
          end
        end

        def authorized_call(env, &b)
          @app.call(env.merge(auth_header), &b)
        end

        def auth_header
          {'HTTP_AUTHORIZATION' => "Basic #{encoded_login}"}
        end

        def encoded_login
          ["#{@username}:#{@password}"].pack("m*")
        end

        def parse_response(status, headers = {}, body = [])
          Rack::Response.new(body, status, headers)
        end

        class Challenge < Abstract::Challenge
          def basic?
            :basic == scheme
          end
        end
      end
    end
  end
end
