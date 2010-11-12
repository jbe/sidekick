require 'rubygems'
require 'rake'
require 'rake/clean'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sidekick"
    gem.summary = %Q{Automatically run common development tasks on events.}
    gem.description = %Q{Automatically run common development tasks on events, as prescribed in a local .sidekick file. Easy, powerful DSL. Powered by EventMachine.}
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


=begin
require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "sidekick #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
=end

require 'rocco/tasks'
Rocco::make 'website/'

desc 'Build docco'
task :docs => [:clear_docs, :rocco]
directory 'website/'

task :clear_docs do
  sh 'rm website/*.html'
end


