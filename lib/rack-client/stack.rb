module RackClient
  class Stack
    include Rack::Test::Methods

    def initialize
      @options = {}
      @stack = []
    end

    def use(middleware, *args, &block)
      @stack << [middleware, args, block]
    end

    def body(access)
      @options[:body] = access
    end

    def app
      builder = Rack::Builder.new
      @stack.each do |(middleware,args,block)|
        builder.use middleware, *args, &block
      end
      builder.run HTTP
      builder.to_app
    end
  end
end
