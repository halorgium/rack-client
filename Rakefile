require 'rake'
require 'rake/clean'
require 'rspec/core/rake_task'

$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'rack/client/version'

desc 'Install the package as a gem.'
task :install => [:clean, :package] do
  gem = Dir['pkg/*.gem'].first
  sh "sudo gem install --no-rdoc --no-ri --local #{gem}"
end

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w[ -c -f documentation -r ./spec/spec_helper.rb ]
  t.pattern = 'spec/**/*_spec.rb'
end

task :default  => :spec
