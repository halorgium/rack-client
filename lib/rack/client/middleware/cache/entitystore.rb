module Rack
  module Client
    module Cache
      class EntityStore
        # Read body calculating the SHA1 checksum and size while
        # yielding each chunk to the block. If the body responds to close,
        # call it after iteration is complete. Return a two-tuple of the form:
        # [ hexdigest, size ].
        def slurp(body)
          digest, size = Digest::SHA1.new, 0
          body.each do |part|
            size += bytesize(part)
            digest << part
            yield part
          end
          body.close if body.respond_to? :close
          [digest.hexdigest, size]
        end

        if ''.respond_to?(:bytesize)
          def bytesize(string); string.bytesize; end
        else
          def bytesize(string); string.size; end
        end

        private :slurp, :bytesize

        class Heap < EntityStore

          # Create the store with the specified backing Hash.
          def initialize(hash={})
            @hash = hash
          end

          # Determine whether the response body with the specified key (SHA1)
          # exists in the store.
          def exist?(key)
            @hash.include?(key)
          end

          # Return an object suitable for use as a Rack response body for the
          # specified key.
          def open(key)
            (body = @hash[key]) && body.dup
          end

          # Read all data associated with the given key and return as a single
          # String.
          def read(key)
            (body = @hash[key]) && body.join
          end

          # Write the Rack response body immediately and return the SHA1 key.
          def write(body)
            buf = []
            key, size = slurp(body) { |part| buf << part }
            @hash[key] = buf
            [key, size]
          end

          # Remove the body corresponding to key; return nil.
          def purge(key)
            @hash.delete(key)
            nil
          end

          def self.resolve(uri)
            new
          end
        end

        HEAP = Heap
        MEM  = Heap
      end
    end
  end
end
