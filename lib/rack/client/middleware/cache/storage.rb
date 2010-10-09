module Rack
  module Client
    module Cache
      class Storage
        def initialize
          @metastores = {}
          @entitystores = {}
        end

        def resolve_metastore_uri(uri)
          @metastores[uri.to_s] ||= create_store(MetaStore, uri)
        end

        def resolve_entitystore_uri(uri)
          @entitystores[uri.to_s] ||= create_store(EntityStore, uri)
        end

        def create_store(type, uri)
          if uri.respond_to?(:scheme) || uri.respond_to?(:to_str)
            uri = URI.parse(uri) unless uri.respond_to?(:scheme)
            if type.const_defined?(uri.scheme.upcase)
              klass = type.const_get(uri.scheme.upcase)
              klass.resolve(uri)
            else
              fail "Unknown storage provider: #{uri.to_s}"
            end
          end
        end

        def clear
          @metastores.clear
          @entitystores.clear
          nil
        end

        @@singleton_instance = new
        def self.instance
          @@singleton_instance
        end
      end
    end
  end
end
