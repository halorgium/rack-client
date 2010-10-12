module Rack
  module Client
    class Simple < Base

      class CollapsedResponse < Response
        extend Forwardable
        attr_accessor :response

        def_delegators :response, :[], :[]=, :close, :delete_cookie, :each,
                                  :empty?, :finish, :headers, :redirect,
                                  :set_cookie, :status, :to_a, :write
        def_delegator  :response, :body, :chunked_body

        def initialize(*tuple)
          @response, @body = Response.new(*tuple), nil
        end

        def body
          collapse! unless @body
          @body
        end

        def collapse!
          @body = ''
          each {|chunk| @body << chunk }
          @body
        end
      end

      def initialize(app, url = nil)
        super(app)
        @base_uri = URI.parse(url) unless url.nil?
      end

      %w[ options get head delete trace ].each do |method|
        eval <<-RUBY, binding, __FILE__, __LINE__ + 1
          def #{method}(url, headers = {}, query_params = {}, &block)
            request('#{method.upcase}', url, headers, nil, query_params, &block)
          end
        RUBY
      end

      %w[ post put ].each do |method|
        eval <<-RUBY, binding, __FILE__, __LINE__ + 1
          def #{method}(url, headers = {}, body_or_params = nil, query_params = {})
            request('#{method.upcase}', url, headers, body_or_params, query_params, &block)
          end
        RUBY
      end

      def request(method, url, headers = {}, body_or_params = nil, query_params = {})
        tuple = request_tuple(url, headers, body_or_params, query_params)
        if block_given?
          super(method, *tuple) {|*tuple| yield CollapsedResponse.new(*tuple) }
        else
          CollapsedResponse.new(*super(method, *tuple))
        end
      end

      def request_tuple(url, headers = {}, body_or_params = nil, query_params = {}, &block)
        headers, query_or_params = {}, headers if query_or_params.nil?
        query_hash = Hash === query_or_params ? query_or_params : Utils.build_query(query_or_params)

        uri = URI.parse(url)

        unless query_params.empty?
          uri.query = Utils.build_nested_query(Utils.parse_nested_query(uri.query).merge(query_phrams))
        end

        body = Hash === body_or_params ? Utils.build_nested_query(body_or_params) : body_or_params

        return uri.to_s, headers, body
      end

      def build_env(request_method, url, headers = {}, body = nil)
        uri = @base_uri.nil? ? URI.parse(url) : @base_uri + url
        super(request_method, uri.to_s, headers, body)
      end
    end
  end
end
