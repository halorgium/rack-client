module Rack
  module Client
    module Parser
      class Response < Rack::Client::Response
        def finish(*)
          super
        ensure
          parse_body_as(headers['Content-Type']) if headers['Content-Type']
        end

        def parse_body_as(content_type)
          if parser = Base.lookup(content_type)
            headers['rack-client.body_collection'] = parser.new.decode(body)
          end
        end
      end
    end
  end
end
