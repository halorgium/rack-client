module Rack
  module Client
    module Auth
      module Digest
        class MD5 < Rack::Auth::Digest::MD5
          include Rack::Client::DualBand

          def initialize(app, realm, username, password, options = {})
            @app, @realm, @username, @password = app, realm, username, password
            @nc = 0
          end

          def sync_call(env)
            request   = Rack::Request.new(env)
            response  = parse_response(*@app.call(env))
            attempt   = Digest::Attempt.new(request, response, @realm, @username, @password)

            if attempt.required? && attempt.digest? && valid?(attempt)
              return @app.call(env.merge(authorization(attempt)))
            end

            response.finish
          end

          def async_call(env)
            @app.call(env) do |response_parts|
              request   = Rack::Request.new(env)
              response  = parse_response(*response_parts)
              attempt   = Digest::Attempt.new(request, response, @realm, @username, @password)

              if attempt.required? && attempt.digest? && valid?(attempt)
                @app.call(env.merge(authorization(attempt))) {|response_parts| yield response_parts }
              else
                @app.call(env) {|response_parts| yield response_parts }
              end
            end
          end

          def valid?(attempt)
            valid_opaque?(attempt) && valid_nonce?(attempt)
          end

          def valid_opaque?(attempt)
            !(attempt.opaque.nil? || attempt.opaque.empty?)
          end

          def valid_nonce?(attempt)
            attempt.nonce.valid?
          end

          def authorization(attempt)
            return 'HTTP_AUTHORIZATION' => "Digest #{params_for(attempt)}"
          end

          def params_for(attempt)
            nc = next_nc

            Rack::Auth::Digest::Params.new do |params|
              params['username']  = @username
              params['realm']     = @realm
              params['nonce']     = attempt.nonce.to_s
              params['uri']       = attempt.path
              params['qop']       = attempt.qop
              params['nc']        = nc
              params['cnonce']    = attempt.cnonce
              params['response']  = attempt.response(nc)
              params['opaque']    = attempt.opaque
            end
          end

          def next_nc
            sprintf("%08x", @nc += 1)
          end

          def parse_response(status, headers = {}, body = [])
            Rack::Response.new(body, status, headers)
          end
        end
      end
    end
  end
end
