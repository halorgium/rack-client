module Rack
  module Client
    class Simple < Base

      def self.new(app, *a, &b)
        app = inject_middleware(app) if middlewares.any?

        super(app, *a, &b)
      end

      def self.middlewares
        @middlewares ||= []
      end

      def self.use(middleware, *args)
        middlewares << [middleware, args]
      end

      def self.inject_middleware(app)
        middlewares = self.middlewares

        Rack::Builder.app do |builder|
          middlewares.each do |(middleware, args)|
            builder.use middleware, *args
          end

          builder.run app
        end
      end

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
          def #{method}(url, headers = {}, body_or_params = nil, query_params = {}, &block)
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
        query_hash = Hash === query_params ? query_params : Utils.build_query(query_params)

        uri = url.is_a?(URI) ? url : URI.parse(url)

        unless query_params.empty?
          uri.query = Utils.build_nested_query(Utils.parse_nested_query(uri.query).merge(query_params))
        end

        body = Hash === body_or_params ? Utils.build_nested_query(body_or_params) : body_or_params

        return uri.to_s, headers, body
      end

      def build_env(request_method, url, headers = {}, body = nil)
        uri = @base_uri.nil? ? URI.parse(url) : @base_uri + url

        env = super(request_method, uri.to_s, headers, body)

        env['HTTP_HOST']       ||= http_host_for(uri)
        env['HTTP_USER_AGENT'] ||= http_user_agent

        env
      end

      def http_host_for(uri)
        if uri.to_s.include?(":#{uri.port}")
          [uri.host, uri.port].join(':')
        else
          uri.host
        end
      end

      def http_user_agent
        "rack-client #{VERSION} (app: #{@app.class})"
      end
    end
  end
end
