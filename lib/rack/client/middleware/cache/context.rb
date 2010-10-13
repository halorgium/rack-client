module Rack
  module Client
    module Cache
      class Context
        include Options
        include DualBand

        def initialize(app, options = {})
          @app = app

          initialize_options options
        end

        def sync_call(env)
          @trace = []
          request = Request.new(options.merge(env))

          return @app.call(env) unless request.cacheable?

          response = Response.new(*@app.call(env = request.env))

          if response.not_modified?
            response = lookup(request)
          elsif response.cacheable?
            store(request, response)
          else
            pass(request)
          end

          trace = @trace.join(', ')
          response.headers['X-Rack-Client-Cache'] = trace

          response.to_a
        end

        def async_call(env)
          @trace = []
          request = Request.new(options.merge(env))

          if request.cacheable?
            @app.call(env = request.env) do |response_parts|
              response = Response.new(*response_parts)

              if response.not_modified?
                response = lookup(request)
              elsif response.cacheable?
                store(request, response)
              else
                pass(env)
              end

              trace = @trace.join(', ')
              response.headers['X-Rack-Client-Cache'] = trace

              yield response.to_a
            end
          else
            @app.call(env) {|*response| yield *response }
          end
        end

        def lookup(request)
          begin
            entry = metastore.lookup(request, entitystore)
            record :fresh
            entry
          rescue Exception => e
            log_error(e)
            return pass(request)
          end
        end

        def store(request, response)
          metastore.store(request, response, entitystore)
          record :store
        end

        def metastore
          uri = options['rack-client-cache.metastore']
          storage.resolve_metastore_uri(uri)
        end

        def entitystore
          uri = options['rack-client-cache.entitystore']
          storage.resolve_entitystore_uri(uri)
        end

        # Record that an event took place.
        def record(event)
          @trace << event
        end

        def pass(request)
          record :pass
          forward(request)
        end

        def forward(request)
          Response.new(*@app.call(request.env))
        end
      end
    end
  end
end
