require 'rubygems'
require 'rake'
require 'rake/clean'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sidekick"
    gem.summary = %Q{Automatically run common development tasks on events, as defined by a local .sidekick file.}
    gem.description = %Q{Automatically run common development tasks on events, as defined by a local .sidekick file. Easy, powerful DSL. Powered by EventMachine. Easy to extend.}
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


require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "sidekick #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


require 'rocco/tasks'
Rocco::make 'annotated/'

desc 'Build rocco docs'
task :docs => [:rocco, 'website/index.html']
directory 'annotated/'

# Make index.html a copy of rocco.html
file 'website/index.html' => 'website/sidekick.html' do |f|
  cp 'website/sidekick.html', 'website/index.html', :preserve => true
end

CLEAN.include 'website/index.html'
task :doc => :docs

# GITHUB PAGES ===============================================================


