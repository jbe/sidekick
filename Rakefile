require 'rubygems'
require 'rake'

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
task :docs => [:rocco, 'annotated/index.html']
directory 'annotated/'

# Make index.html a copy of rocco.html
file 'annotated/index.html' => 'annotated/sidekick.html' do |f|
  cp 'annotated/sidekick.html', 'annotated/index.html', :preserve => true
end

CLEAN.include 'annotated/index.html'
task :doc => :docs

# GITHUB PAGES ===============================================================


desc 'Update gh-pages branch'
task :pages => ['annotated/.git', :docs] do
  rev = `git rev-parse --short HEAD`.strip
  Dir.chdir 'annotated' do
    sh "git add *.html"
    sh "git commit -m 'rebuild pages from #{rev}'" do |ok,res|
      if ok
        verbose { puts "gh-pages updated" }
        sh "git push -q o HEAD:gh-pages"
      end
    end
  end
end

# Update the pages/ directory clone
file 'annotated/.git' => ['annotated/', '.git/refs/heads/gh-pages'] do |f|
  sh "cd annotated && git init -q && git remote add o ../.git" if !File.exist?(f.name)
  sh "cd annotated && git fetch -q o && git reset -q --hard o/gh-pages && touch ."
end
CLOBBER.include 'annotated/.git'


