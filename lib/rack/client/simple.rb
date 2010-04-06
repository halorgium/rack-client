module Rack
  module Client
    class Simple < Base

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
    end
  end
end
