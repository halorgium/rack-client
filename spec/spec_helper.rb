Bundler.require_env(:test)

require File.expand_path(File.dirname(__FILE__) + "/../lib/rack/client")

Spec::Runner.configure do |config|
  config.include(Webrat::Matchers)
end
