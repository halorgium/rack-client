module Rack
  module Client
    module Auth
      module Digest
        class Attempt < Abstract::Attempt
          def initialize(request, response, realm, username, password)
            super(request, response)
            @realm, @username, @password = realm, username, password
          end

          def digest?
            :digest == scheme
          end

          def cnonce
            @cnonce ||= Rack::Auth::Digest::Nonce.new.to_s
          end

          def response(nc)
            H([ A1(), nonce, nc, cnonce, qop, A2() ] * ':')
          end

          def A1
            H([ @username, @realm, @password ] * ':')
          end

          def A2
            H([ request_method, path ] * ':')
          end

          def H(data)
            ::Digest::MD5.hexdigest(data)
          end
        end
      end
    end
  end
end
