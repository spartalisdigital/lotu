require 'rubygems'
require 'rake'
require 'psych' if RUBY_VERSION.include?( '1.9' )

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "lotu"
    gem.summary = %Q{A simple, agile Ruby game development framework.}
    gem.description = %Q{lotu aims to bring an agile and simple game development framework to life. It provides useful abstractions so you can concentrate on developing your game.}
    gem.email = "dev@lobotuerto.com"
    gem.homepage = "http://github.com/lobo-tuerto/lotu"
    gem.authors = ["lobo_tuerto"]
    gem.add_dependency "gosu", ">= 0.7.27.1"
    gem.add_development_dependency "rspec", ">= 2.5.0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "lotu #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# rspec rake task stuff
require 'rspec/core/rake_task'
desc "Run the tests under spec"
RSpec::Core::RakeTask.new do |t|
end

# default rake task
task :default => :spec
