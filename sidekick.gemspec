# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sidekick}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jostein Berre Eliassen,"]
  s.date = %q{2010-10-25}
  s.default_executable = %q{sidekick}
  s.description = %q{Automatically run common development tasks on events, as defined by a local .sidekick file. Easy, powerful dsl. Several pre-defined triggers. Helper methods for common tasks. Easy to extend with new triggers and helpers.}
  s.email = %q{post@jostein.be}
  s.executables = ["sidekick"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.textile"
  ]
  s.files = [
    ".document",
     ".gitignore",
     ".sidekick",
     "LICENSE",
     "README.textile",
     "Rakefile",
     "VERSION",
     "bin/sidekick",
     "lib/sidekick.rb",
     "lib/sidekick/helpers.rb",
     "lib/sidekick/triggers.rb",
     "lib/sidekick/triggers/watch.rb",
     "sidekick.gemspec",
     "test/helper.rb",
     "test/test_sidekick.rb"
  ]
  s.homepage = %q{http://github.com/jbe/sidekick}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Automatically run common development tasks on events, as defined by a local .sidekick file.}
  s.test_files = [
    "test/helper.rb",
     "test/test_sidekick.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
  end
end

