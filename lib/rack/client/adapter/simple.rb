module Rack
  module Client
    class Simple < Base

      def initialize(app, url = nil)
        super(app)
        @base_uri = URI.parse(url) unless url.nil?
      end

      %w[ options get head delete trace ].each do |method|
        eval <<-RUBY, binding, __FILE__, __LINE__ + 1
          def #{method}(url, headers = {}, query_or_params = nil)
            headers, query_or_params = {}, headers if query_or_params.nil?
            query_hash = Hash === query_or_params ? query_or_params : Utils.build_query(query_or_params)

            uri = URI.parse(url)
            uri.query = Utils.build_query(Utils.parse_query(uri.query).merge(query_hash))

            if block_given?
              super(uri.to_s, headers) {|*tuple| yield Response.new(*tuple) }
            else
              return Response.new(*super(uri.to_s, headers))
            end
          end
        RUBY
      end

      %w[ post put ].each do |method|
        eval <<-RUBY, binding, __FILE__, __LINE__ + 1
          def #{method}(url, headers = {}, body_or_params = nil)
            headers, body_or_params = {}, headers if body_or_params.nil?
            body = Hash === body_or_params ? Utils.build_query(body_or_params) : body_or_params

            if block_given?
              super(url, headers, body) {|*tuple| yield Response.new(*tuple) }
            else
              return Response.new(*super(url, headers, body))
            end
          end
        RUBY
      end

      def build_env(request_method, url, headers = {}, body = nil)
        uri = @base_uri.nil? ? URI.parse(url) : @base_uri + url
        super(request_method, uri.to_s, headers, body)
      end
    end
  end
end
