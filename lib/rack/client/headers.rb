module Rack
  module Client
    class Headers < Hash
      def self.from(env)
        new env.reject {|(header,_)| header !~ %r'^HTTP_' unless %w( CONTENT_TYPE CONTENT_LENGTH ).include?(header) }
      end

      def initialize(headers = {})
        super
        merge!(headers)
      end

      def clean(header)
        header.gsub(/HTTP_/, '').gsub('_', '-').gsub(/(\w+)/) do |matches|
          matches.downcase.sub(/^./) do |char|
            char.upcase
          end
        end
      end

      def to_http
        self.inject({}) {|h,(header,value)| h.update(clean(header) => value) }
      end

      def to_env
        self.inject({}) {|h,(header,value)| h.update((rackish?(header) ? header : rackify(header)) => value) }
      end

      def rackish?(header)
        case header
        when 'CONTENT_TYPE', 'CONTENT_LENGTH' then true
        when /^rack[-.]/                      then true
        when /^HTTP_/                         then true
        else false
        end
      end

      def rackify(original)
        header =  original.upcase.gsub('-', '_')

        case header
        when 'CONTENT_TYPE', 'CONTENT_LENGTH' then header
        when /^HTTP_/                         then header
        else "HTTP_#{header}"
        end
      end
    end
  end
end
