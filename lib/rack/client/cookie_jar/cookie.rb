module Rack
  module Client
    module CookieJar
      class Cookie
        extend Forwardable

        def self.from(header)
          parts = header.split('; ')
          tuple = parts.shift.split('=')

          metadata = parts.map {|s| s.split('=') }.inject({}) do |h, (k,v)|
            h.update(k.to_sym => v)
          end

          new(tuple.first, tuple.last, metadata)
        end

        def initialize(key, value, metadata = {})
          @key, @value, @metadata = key, value, metadata
        end

        def domain
          @metadata[:domain]
        end

        def path
          @metadata[:path]
        end

        def key
          Key.new(@key, domain, path)
        end

        def to_header
          "#{@key}=#{@value}" << ( '; ' + @metadata.map {|(k,v)| "#{k}=#{v}" } * '; ')
        end
      end
    end
  end
end
