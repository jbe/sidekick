# *Sidekick* is a simple event driven background assistant. Among other things, you can use it to automatically compile assets, test code, restart servers and so on - as prescribed per project, in a `.sidekick` file. It is powered by [EventMachine](http://github.com/eventmachine/eventmachine) and [Tilt](http://github.com/rtomayko/tilt).
#
# This is the annotated source code. See the [README](http://github.com/jbe/sidekick#readme) too.
#
# The default trigger definitions and helper methods -- commonly referred to as actions -- are automagically required and included from `lib/sidekick/actions/**.rb`.

require 'fileutils'
require 'eventmachine'

module Sidekick

  module Sidekick::Actions
    Dir[
      File.join File.dirname(__FILE__), *%w{sidekick actions **.rb}
      ].each {|path| load path }

    constants.each do |name|
      include const_get(name) if const_get(name).is_a?(Module)
    end
  end

  STOP_CALLBACKS = [] # called on shutdown

  Context = Module.new.extend(Actions)

  def self.run!(path='.sidekick')
    ensure_config_exists(path)

    Signal.trap(:INT) { stop }

    EventMachine.run do
      Context.module_eval(IO.read(path), path)
    end
  end

  def self.ensure_config_exists(path)
    unless File.exists?(path)
      puts "Generate #{path}? (Y/n)"
      STDIN.gets =~ /^N|n/ ? exit : FileUtils.cp(template_path, path)
    end
  end

  def self.template_path
    File.join File.dirname(__FILE__), *%w{sidekick template}
  end

  def self.stop(msg=nil)
    STOP_CALLBACKS.each {|c| c.call }
    EventMachine.stop
    puts "\n#{msg}" if msg
  end

end
