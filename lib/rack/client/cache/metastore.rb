module Rack
  module Client
    module Cache
      class MetaStore

        def lookup(request, entity_store)
          key = cache_key(request)
          entries = read(key)

          # bail out if we have nothing cached
          return nil if entries.empty?

          # find a cached entry that matches the request.
          env = request.env
          match = entries.detect{|req,res| requests_match?(res['Vary'], env, req)}
          return nil if match.nil?

          req, res = match
          if body = entity_store.open(res['X-Content-Digest'])
            restore_response(res, body)
          else
            # TODO the metastore referenced an entity that doesn't exist in
            # the entitystore. we definitely want to return nil but we should
            # also purge the entry from the meta-store when this is detected.
          end
        end

        # Write a cache entry to the store under the given key. Existing
        # entries are read and any that match the response are removed.
        # This method calls #write with the new list of cache entries.
        def store(request, response, entity_store)
          key = cache_key(request)
          stored_env = persist_request(request)

          # write the response body to the entity store if this is the
          # original response.
          if response.headers['X-Content-Digest'].nil?
            digest, size = entity_store.write(response.body)
            response.headers['X-Content-Digest'] = digest
            response.headers['Content-Length'] = size.to_s unless response.headers['Transfer-Encoding']
            response.body = entity_store.open(digest)
          end

          # read existing cache entries, remove non-varying, and add this one to
          # the list
          vary = response.vary
          entries =
            read(key).reject do |env,res|
            (vary == res['Vary']) &&
              requests_match?(vary, env, stored_env)
            end

          headers = persist_response(response)
          headers.delete 'Age'

          entries.unshift [stored_env, headers]
          write key, entries
          key
        end

        def cache_key(request)
          keygen = request.env['rack-client-cache.cache_key'] || Key
          keygen.call(request)
        end

        # Extract the environment Hash from +request+ while making any
        # necessary modifications in preparation for persistence. The Hash
        # returned must be marshalable.
        def persist_request(request)
          env = request.env.dup
          env.reject! { |key,val| key =~ /[^0-9A-Z_]/ }
          env
        end

        def persist_response(response)
          hash = response.headers.to_hash
          hash['X-Status'] = response.status.to_s
          hash
        end

        # Converts a stored response hash into a Response object. The caller
        # is responsible for loading and passing the body if needed.
        def restore_response(hash, body=nil)
          status = hash.delete('X-Status').to_i
          Rack::Client::Cache::Response.new(status, hash, body)
        end

        # Determine whether the two environment hashes are non-varying based on
        # the vary response header value provided.
        def requests_match?(vary, env1, env2)
          return true if vary.nil? || vary == ''
          vary.split(/[\s,]+/).all? do |header|
            key = "HTTP_#{header.upcase.tr('-', '_')}"
            env1[key] == env2[key]
          end
        end

        class Heap < MetaStore
          def initialize(hash={})
            @hash = hash
          end

          def read(key)
            @hash.fetch(key, []).collect do |req,res|
              [req.dup, res.dup]
            end
          end

          def write(key, entries)
            @hash[key] = entries
          end

          def purge(key)
            @hash.delete(key)
            nil
          end

          def to_hash
            @hash
          end

          def self.resolve(uri)
            new
          end
        end

        HEAP = Heap
        MEM = HEAP

      end
    end
  end
end
