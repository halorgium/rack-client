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
            response  = Response.new(*@app.call(env))
            challenge = Digest::Challenge.new(request, response, @realm, @username, @password)

            if challenge.required? && challenge.digest? && valid?(challenge)
              return @app.call(env.merge(authorization(challenge)))
            end

            response.finish
          end

          def async_call(env)
            @app.call(env) do |response_parts|
              request   = Rack::Request.new(env)
              response  = Response.new(*response_parts)
              challenge = Digest::Challenge.new(request, response, @realm, @username, @password)

              if challenge.required? && challenge.digest? && valid?(challenge)
                @app.call(env.merge(authorization(challenge))) {|response_parts| yield response_parts }
              else
                @app.call(env) {|response_parts| yield response_parts }
              end
            end
          end

          def valid?(challenge)
            valid_opaque?(challenge) && valid_nonce?(challenge)
          end

          def valid_opaque?(challenge)
            !(challenge.opaque.nil? || challenge.opaque.empty?)
          end

          def valid_nonce?(challenge)
            challenge.nonce.valid?
          end

          def authorization(challenge)
            return 'HTTP_AUTHORIZATION' => "Digest #{params_for(challenge)}"
          end

          def params_for(challenge)
            nc = next_nc

            Rack::Auth::Digest::Params.new do |params|
              params['username']  = @username
              params['realm']     = @realm
              params['nonce']     = challenge.nonce.to_s
              params['uri']       = challenge.path
              params['qop']       = challenge.qop
              params['nc']        = nc
              params['cnonce']    = challenge.cnonce
              params['response']  = challenge.response(nc)
              params['opaque']    = challenge.opaque
            end
          end

          def next_nc
            sprintf("%08x", @nc += 1)
          end
        end
      end
    end
  end
end
