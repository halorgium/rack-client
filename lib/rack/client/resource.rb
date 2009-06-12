class Rack::Client::Resource < Rack::Builder
  include Rack::Test::Methods

  def initialize(*args, &block)
    @endpoint = Rack::Client::HTTP
    super(*args, &block)
  end

  def endpoint(app, url = "http://example.org/")
    @endpoint = Rack::URLMap.new(url => app)
  end

  def app
    run @endpoint
    to_app
  end
end 
