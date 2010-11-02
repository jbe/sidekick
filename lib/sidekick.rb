# *Sidekick* is a simple event driven background assistant. Among other things, you can use it to automatically compile assets, test code, restart servers and so on - as prescribed per project, in a `.sidekick` file. It is powered by [EventMachine](http://github.com/eventmachine/eventmachine) and [Tilt](http://github.com/rtomayko/tilt).
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
  #Basically, the job of a trigger definition is to take the parameters and the block from a directive in the `.sidekick` file, and then hook into EventMachine in some way to set up the trigger. -- Just have a look at the [default trigger library](http://jbe.github.com/sidekick/triggers.html).
  #
  # By using Ruby's `method_missing`, we can forward method calls to the registered trigger definitions. Any module can thereby extend the `Sidekick::Triggers` module in order to expose the defined triggers as if they were methods.
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

  # This part includes the default trigger definitions and helper methods. `Sidekick::Helpers` automagically loads the code in `sidekick/helpers` and then includes its own sub-modules.

  module Sidekick::Helpers
    Dir[File.dirname(__FILE__) + '/sidekick/helpers/**.rb'
      ].each {|path| load path }

    constants.each do |name|
      include const_get(name) if const_get(name).is_a?(Module)
    end
  end

  require 'sidekick/triggers'

  # The `.sidekick` file is evaluated in the `Sidekick::Context` module, which exposes DSL style methods by extending `Sidekick::Triggers` and `Sidekick::Helpers`.
  Context = Module.new
  Context.extend Triggers
  Context.extend Helpers


  # `Sidekick.run!` reads and applies the `.sidekick` file, wrapping the setup phase inside `EM.run { .. }`, thus starting the event loop.
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

  def self.stop(msg=nil)
    EventMachine.stop
    puts "\n#{msg}" if msg
  end

end
