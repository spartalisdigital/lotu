require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "lotu"
    gem.summary = %Q{lotu game development framework}
    gem.description = %Q{lotu - Ruby game development framework}
    gem.email = "dev@lobotuerto.com"
    gem.homepage = "http://github.com/lobo-tuerto/lotu"
    gem.authors = ["lobo_tuerto"]
    gem.add_development_dependency "gosu", ">= 0.7.18"
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
