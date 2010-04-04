module Rack
  module Client
    module Cache
      class Context < Rack::Cache::Context
        include Rack::Client::Cache::Options

        def call!(env)
          @trace = []
          @request = Request.new(options.merge(env))

          return @backend.call(env) unless @request.cacheable?

          response = Response.new(*@backend.call(@env = @request.env))

          if response.not_modified?
            response = lookup
          elsif response.cacheable?
            store(response)
          else
            pass
          end

          trace = @trace.join(', ')
          response.headers['X-Rack-Client-Cache'] = trace

          response.to_a
        end

        def lookup
          begin
            entry = metastore.lookup(@request, entitystore)
            record :fresh
            entry
          rescue Exception => e
            log_error(e)
            return pass
          end
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


