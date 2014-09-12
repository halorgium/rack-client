source 'http://rubygems.org'
gemspec

ruby_version = Gem::Version.new(RUBY_VERSION.dup)
ruby_19      = Gem::Version.new('1.9')
ruby_20      = Gem::Version.new('2.0')

group :optional do
  gem 'rack-cache', :require => 'rack/cache'
  gem 'rack-contrib', :require => 'rack/contrib'
end

group :test do
  gem 'rake'
  gem 'sinatra', :require => 'sinatra/base'
  gem 'realweb'

  if ruby_version >= ruby_20
    gem 'em-synchrony'
  elsif ruby_version >= ruby_19
    gem 'debugger' if RUBY_ENGINE == 'ruby'
    gem 'em-synchrony'
  else
    gem 'ruby-debug'
    gem 'mongrel'
    gem 'cgi_multipart_eof_fix'
  end
end
