require 'json'

module Rack
  module Client
    module Parser
      class JSON < Parser::Base

        content_type 'application', 'json'

        def encode(input)
          output = StringIO.new

          input.each do |object|
            ::JSON.dump(object, output)
          end

          output
        end

        def decode(body)
          BodyCollection.new do |collection|
            begin
              data = if body.respond_to? :read
                       body.read
                     elsif body.respond_to? :to_path
                       File.read(body.to_path)
                     else
                       io = StringIO.new

                       body.each do |part|
                         io << part
                       end

                       io.rewind
                       io.read
                     end

              case result = ::JSON.parse(data)
              when Array then result.each {|object| collection << object }
              else collection << result
              end

              collection.finish
            ensure
              body.close if body.respond_to? :close
            end
          end
        end
      end

      Json = JSON
    end
  end
end
