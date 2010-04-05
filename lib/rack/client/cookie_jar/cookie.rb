module Rack
  module Client
    module CookieJar
      class Cookie < Struct.new(:key, :value, :domain, :path)

        def self.merge(bottom, top)
          bottom.reject {|a| top.any? {|b| a == b } } | top
        end

        def self.parse(raw)
          raw.split(', ').map {|header| from(header) }
        end

        def self.from(header)
          data  = header.split('; ')
          tuple = data.shift.split('=')
          parts = data.map {|s| s.split('=') }

          new parts.inject('key'=> tuple.first, 'value'=> tuple.last) {|h,(k,v)| h.update(k => v)}
        end

        def initialize(parts = {})
          parts.each do |k,v|
            send(:"#{k}=", v)
          end
        end

        def to_key
          [ key, domain, path ] * ';'
        end

        def to_header
          hash = members.zip(values).inject({}) {|h,(k,v)| h.update(k => v) }.reject {|k,v| v.nil?}
          "#{hash.delete('key')}=#{hash.delete('value')}" << ('; ' + hash.map {|(k,v)| "#{k}=#{v}" } * '; ' unless hash.empty?)
        end

        def eql?(other)
          to_key == other.to_key
        end

        def match?(domain, path)
          fuzzy_domain_equal(domain) && fuzzy_path_equal(path)
        end

        def fuzzy_domain_equal(other_domain)
          if domain =~ /^\./
            other_domain =~ /#{Regexp.escape(domain)}$/
          else
            domain == other_domain
          end
        end

        def fuzzy_path_equal(other_path)
          path == '/' || path == other_path
        end
      end
    end
  end
end
