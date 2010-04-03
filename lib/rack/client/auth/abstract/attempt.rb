module Rack
  module Client
    module Auth
      module Abstract
        class Attempt
          extend Forwardable

          def_delegators :@request, :request_method, :path
          def_delegators :@response, :status, :headers

          def initialize(request, response)
            @request, @response = request, response
          end

          def required?
            status == 401
          end

          def unspecified?
            scheme.nil?
          end

          def www_authenticate
            @www_authenticate ||= headers.detect {|h,_| h =~ /^WWW-AUTHENTICATE$/i }
          end

          def parts
            @parts ||= www_authenticate if www_authenticate
          end

          def scheme
            @scheme ||= www_authenticate.last[/^(\w+)/, 1].downcase.to_sym if www_authenticate
          end

          def nonce
            @nonce ||= Rack::Auth::Digest::Nonce.parse(params['nonce'])
          end

          def params
            @params ||= Rack::Auth::Digest::Params.parse(parts.last)
          end

          def method_missing(sym)
            if params.has_key? key = sym.to_s
              return params[key]
            end
            super
          end
        end
      end
    end
  end
end
