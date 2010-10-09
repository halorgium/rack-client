module Rack
  module Client
    module CookieJar
      class CookieStore
        def store(cookie)
          write cookie.to_key, cookie.to_header
        end

        def match(domain, path)
          cookies = map {|header| Cookie.from(header) }
          cookies.select {|cookie| cookie.match?(domain, path) }
        end

        class Heap < CookieStore
          def initialize
            @heap = Hash.new {|h,k| h[k] = [] }
          end

          def write(key, value)
            @heap[key] << value
          end

          def map
            @heap.values.flatten.map {|*a| yield *a }
          end

          def self.resolve(uri)
            new
          end
        end

        HEAP = Heap
      end
    end
  end
end
