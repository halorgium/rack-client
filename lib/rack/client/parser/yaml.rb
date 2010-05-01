require 'yaml'

module Rack
  module Client
    module Parser
      class YAML < Parser::Base

        content_type 'application', 'x-yaml'

        def encode(input)
          output = StringIO.new

          ::YAML.dump(input, output)

          output
        end

        def decode(body)
          BodyCollection.new do |collection|
            begin
              io = if body.respond_to? :to_path
                     File.open(body.to_path, 'r')
                   else
                     io = StringIO.new

                     body.each do |part|
                       io << part
                     end

                     io.rewind
                     io
                   end

              ::YAML.load_documents(io) do |object|
                collection << object
              end

              collection.finish
            ensure
              io.close if io.respond_to? :close
              body.close if body.respond_to? :close
            end
          end
        end
      end

      Yaml = YAML
    end
  end
end
