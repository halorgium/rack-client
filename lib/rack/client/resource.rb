class Rack::Client::Resource < Rack::Builder
  include Rack::Test::Methods
  def initialize(*args, &block)
    @ran = false
    super(*args, &block)
  end

  def run(*args, &block)
    @ran = true
    super(*args, &block)
  end

  def endpoint(app, url = "http://example.org/")
    run Rack::URLMap.new(url => app)
  end

  def to_app(*args, &block)
    run Rack::Client::HTTP unless @ran
    super(*args, &block)
  end
  alias app to_app
end 
