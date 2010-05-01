module Rack
  module Client
    module Parser
      class Base
        CONTENT_TYPE = %r'^([^/]+)/([^;]+)\s?(?:;\s?(.*))?$'

        @@type_table ||= Hash.new {|h,k| h[k] = Hash.new {|hh,kk| hh[kk] = {} } }

        def self.content_type(type, subtype, *parameters)
          type_table[type][subtype][parameters] = self
        end

        def self.type_table
          @@type_table
        end

        def self.lookup(content_type)
          type, subtype, *parameters = content_type.scan(CONTENT_TYPE).first

          type_table[type][subtype][parameters.compact]
        end
      end
    end
  end
end
