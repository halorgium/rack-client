source "http://rubygems.org"

gemspec

ruby_version = Gem::Version.new(RUBY_VERSION.dup)
ruby_19      = Gem::Version.new('1.9')
ruby_engine  = RUBY_ENGINE if defined?(RUBY_ENGINE)

group :optional do
  gem 'rack-cache', :require => 'rack/cache'
  gem 'rack-contrib', :require => 'rack/contrib'
end

group :test do
  gem 'rake'
  gem 'sinatra', :require => 'sinatra/base'
  gem 'rspec',    '>=2.0.0'
  gem 'realweb'

  if ruby_version >= ruby_19
    gem 'debugger' if ruby_engine == 'ruby' # MRI

    gem 'em-synchrony'
  else
    gem 'ruby-debug'
    gem 'mongrel'
    gem 'cgi_multipart_eof_fix'
  end
end
