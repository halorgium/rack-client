module Rack
  module Client
    module Cache
      class Response < Rack::Cache::Response
        def not_modified?
          status == 304
        end

        alias_method :finish, :to_a
      end
    end
  end
end
