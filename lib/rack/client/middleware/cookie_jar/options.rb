module Rack
  module Client
    module CookieJar
      module Options
        def self.option_accessor(key)
          name = option_name(key)
          define_method(key) { || options[name] }
          define_method("#{key}=") { |value| options[name] = value }
          define_method("#{key}?") { || !! options[name] }
        end

        def options
          @default_options.merge(@options)
        end

        def options=(hash = {})
          @options = hash.each { |key,value| write_option(key, value) }
        end

        def option_name(key)
          case key
          when Symbol ; "rack-client-cookiejar.#{key}"
          when String ; key
          else raise ArgumentError
          end
        end
        module_function :option_name

        option_accessor :storage
        option_accessor :cookiestore
        option_accessor :cookies

        def initialize_options(options={})
          @default_options = {
            'rack-client-cookiejar.storage'     => Storage.new,
            'rack-client-cookiejar.cookiestore' => 'heap:/',
          }
          self.options = options
        end
      end
    end
  end
end
