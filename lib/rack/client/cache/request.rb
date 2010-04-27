module Rack
  module Client
    module Cache
      class Request < Rack::Request
        include Options

        def cacheable?
          request_method == 'GET'
        end

        def env
          return super if @calculating_headers
          cache_control_headers.merge(super)
        end

        def cache_control_headers
          @calculating_headers = true
          return {} unless cacheable?
          entry = metastore.lookup(self, entitystore)

          if entry
            headers_for(entry)
          else
            {}
          end
        ensure
          @calculating_headers = nil
        end

        def headers_for(response)
          return 'HTTP_If-None-Match' => response.etag
        end

        def metastore
          uri = options['rack-client-cache.metastore']
          storage.resolve_metastore_uri(uri)
        end

        def entitystore
          uri = options['rack-client-cache.entitystore']
          storage.resolve_entitystore_uri(uri)
        end
      end
    end
  end
end
