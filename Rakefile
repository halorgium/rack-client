require 'rubygems'
require 'rake'
require "rake/gempackagetask"
require "rake/clean"
require "spec/rake/spectask"

$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'rack/client/version'

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['-c']
end

task :default  => :spec

spec = Gem::Specification.new do |s|
  s.name              = "rack-client"
  s.rubyforge_project = s.name
  s.version           = Rack::Client::VERSION
  s.author            = "Tim Carey-Smith"
  s.email             = "tim" + "@" + "spork.in"
  s.homepage          = "http://github.com/halorgium/rack-client"
  s.summary           = "A client wrapper around a Rack app or HTTP"
  s.description       = s.summary
  s.files             = %w[History.txt LICENSE README.textile Rakefile] + Dir["lib/**/*"] + Dir["demo/**/*"]
  s.test_files        = Dir["spec/**/*"]

  require 'bundler'
  bundle = Bundler::Definition.from_gemfile("Gemfile")
  bundle.dependencies.
    select { |d| d.groups.include?(:runtime) }.
    each   { |d| s.add_dependency(d.name, d.version_requirements.to_s)  }
end

Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end

desc 'Install the package as a gem.'
task :install => [:clean, :package] do
  gem = Dir['pkg/*.gem'].first
  sh "sudo gem install --no-rdoc --no-ri --local #{gem}"
end
