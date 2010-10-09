module Rack
  module Client
    module CookieJar
      class Storage
        def initialize
          @cookiestores = {}
        end

        def resolve_cookiestore_uri(uri)
          @cookiestores[uri.to_s] ||= create_store(uri)
        end

        def create_store(uri)
          if uri.respond_to?(:scheme) || uri.respond_to?(:to_str)
            uri = URI.parse(uri) unless uri.respond_to?(:scheme)
            if CookieStore.const_defined?(uri.scheme.upcase)
              klass = CookieStore.const_get(uri.scheme.upcase)
              klass.resolve(uri)
            else
              fail "Unknown storage provider: #{uri.to_s}"
            end
          else
            fail "Unknown storage provider: #{uri.to_s}"
          end
        end

        @@singleton_instance = new
        def self.instance
          @@singleton_instance
        end
      end
    end
  end
end
