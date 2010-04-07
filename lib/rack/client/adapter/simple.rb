module Rack
  module Client
    class Simple < Base

      def initialize(app, url = nil)
        super(app)
        @base_uri = URI.parse(url) unless url.nil?
      end

      def delete(url,  headers = {}, body = nil)
        if block_given?
          super {|*tuple| yield Response.new(*tuple) }
        else
          return Response.new(*super)
        end
      end

      def get(url,  headers = {}, body = nil)
        if block_given?
          super {|*tuple| yield Response.new(*tuple) }
        else
          return Response.new(*super)
        end
      end

      def head(url,  headers = {}, body = nil)
        if block_given?
          super {|*tuple| yield Response.new(*tuple) }
        else
          return Response.new(*super)
        end
      end

      def post(url,  headers = {}, body = nil)
        if block_given?
          super {|*tuple| yield Response.new(*tuple) }
        else
          return Response.new(*super)
        end
      end

      def put(url,  headers = {}, body = nil)
        if block_given?
          super {|*tuple| yield Response.new(*tuple) }
        else
          return Response.new(*super)
        end
      end

      def build_env(request_method, url, headers = {}, body = nil)
        uri = @base_uri.nil? ? URI.parse(url) : @base_uri + url
        super(request_method, uri.to_s, headers, body)
      end
    end
  end
end
