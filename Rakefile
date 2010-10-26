require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sidekick"
    gem.summary = %Q{Automatically run common development tasks on events, as defined by a local .sidekick file.}
    gem.description = %Q{Automatically run common development tasks on events, as defined by a local .sidekick file. Easy, powerful dsl including useful pre-defined triggers and helper methods for common tasks. Powered by EventMachine and easy to extend.}
    gem.email = "post@jostein.be"
    gem.homepage = "http://github.com/jbe/sidekick"
    gem.authors = ["Jostein Berre Eliassen,"]
    gem.add_dependency "tilt", ">= 1"
    gem.add_dependency "eventmachine", ">= 0"
    gem.add_dependency "em-dir-watcher", ">= 0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "sidekick #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
