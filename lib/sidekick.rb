# *Sidekick* is a simple event driven background assistant. Among other things, you can use it to automatically compile assets, test code, restart servers and so on - as prescribed per project, in a `.sidekick` file. It is powered by EventMachine and Tilt.
#
# This is the annotated source code. See the [README](http://github.com/jbe/sidekick#readme) too.
#
# ***
#
# Sidekick basically helps you do two things:
#
# -- *Define* named triggers, such as saying that `watch(glob)` means doing something when a file matching `glob` changes, or that `every(duration)` means doing something every `duration` seconds.
#
# -- *Use* the defined triggers with callbacks, such as `watch(**.rb) { notify 'Code change' }`

require 'fileutils'
require 'eventmachine'

module Sidekick

  # This core functionality is provided by `Sidekick::Triggers`.
  #
  # New triggers can be defined by calling `Sidekick::Triggers.register(:trigger_name) { ... }`.
  #
  #Basically, the job of a trigger definition is to take the parameters and the block from a call in `.sidekick` and use it to hook into EventMachine in some way. -- Just have a look at the [default trigger library](http://github.com/jbe/sidekick/blob/master/lib/sidekick/triggers.rb).
  #
  # By using Ruby's `method_missing`, we can forward method calls to the registered trigger definitions. Any module can thereby extend the `Triggers` module in order to expose the defined triggers as if they were methods.
  module Triggers
    @@triggers = {}

    def self.register(name, &block)
      @@triggers[name] = block
    end

    def self.log(str) # used by triggers
      puts str
    end

    def method_missing(name, *args, &blk)
      @@triggers[name] ?
        @@triggers[name].call(blk, *args) : super
    end

    def respond_to?(method)
      super || !!@@triggers[method]
    end

  end

  # A default library of triggers and helpers is included..
  require 'sidekick/triggers'
  require 'sidekick/helpers'

  # The `.sidekick` file is evaluated in a `Sidekick::Context` module, which exposes DSL style methods by extending `Sidekick::Triggers` and `Sidekick::Helpers`.
  Context = Module.new
  Context.extend Triggers
  Context.extend Helpers



  # The `Sidekick.run!` method reads and applies the `.sidekick` file, wrapping the setup phase inside `EM.run { .. }`, and thus begins the event loop.
  def self.run!(path='.sidekick')
    ensure_config_exists(path)

    Signal.trap(:INT) { stop }

    EventMachine.run do
      Context.module_eval(
        open(path) {|f| f.read }, path )
    end
  end

  def self.ensure_config_exists(path)
    unless File.exists?(path)
      puts 'Generate new sidekick file? (Y/n)'
      gets =~ /^N|n/ ? exit :
        FileUtils.cp(File.expand_path('../template',
          __FILE__), path)
    end
  end

  def self.stop(msg=false)
    EventMachine.stop
    puts "\n#{msg}" if msg
  end

end
