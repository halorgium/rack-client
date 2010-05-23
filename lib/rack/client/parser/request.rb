module Rack
  module Client
    module Parser
      class Request < Rack::Request
        def initialize(*)
          super

          if @env['rack-client.body_collection'] && content_type
            parse_input(@env['rack-client.body_collection'])
          end
        end

        def parse_input(collection)
          if parser = Base.lookup(content_type)
            @env['rack.input'] = parser.new.encode(collection)
          end
        end
      end
    end
  end
end
