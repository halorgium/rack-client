module Rack
  module Client
    module CookieJar
      class Key < Struct.new(:key, :domain, :path)
        def ===(other)
          fuzzy_domain_equal(other.domain) && fuzzy_path_equal(other.path)
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
