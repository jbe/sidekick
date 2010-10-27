require 'fileutils'
require 'eventmachine'

module Sidekick

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

  # default library
  require 'sidekick/triggers'
  require 'sidekick/helpers'

  # context in which to evaluate .sidekick file
  Context = Module.new
  Context.extend Triggers
  Context.extend Helpers


  def self.ensure_config_exists(path)
    unless File.exists?(path)
      puts 'Generate new sidekick file? (Y/n)'
      gets =~ /^N|n/ ? exit :
        FileUtils.cp(File.expand_path('../template',
          __FILE__), path)
    end
  end

  # reads and applies the .sidekick file, and begins
  # the event loop.
  def self.run!(path='.sidekick')

    ensure_config_exists(path)

    Signal.trap(:INT) { ::Sidekick.stop }

    EventMachine.run do
      Context.module_eval(
        open(path) {|f| f.read }, path )
    end
  end

  # stops Sidekick gracefully
  def self.stop(msg=false)
    EventMachine.stop
    puts
    puts msg if msg
  end

end
