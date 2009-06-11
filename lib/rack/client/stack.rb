class Rack::Client::Stack
  include Rack::Test::Methods

  def initialize
    @options = {}
    @stack = []
    @endpoint = Rack::Client::HTTP
  end

  def use(middleware, *args, &block)
    @stack << [middleware, args, block]
  end

  def body(access)
    @options[:body] = access
  end

  def endpoint(app, url = "http://example.org/")
    @endpoint = Rack::URLMap.new(url => app)
  end

  def app
    builder = Rack::Builder.new
    @stack.each do |(middleware,args,block)|
      builder.use middleware, *args, &block
    end
    builder.run @endpoint
    builder.to_app
  end
end 
