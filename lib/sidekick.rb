require 'rbconfig'


module Sidekick

  @@timeshare = []
  @@refresh = 1

  class << self
    # creates a module wrapper, which in turn
    # evaluates the .sidekick config file within
    # its own scope
    def run!(conf_path='.sidekick')
      abort('No .sidekick file!') unless File.exists?(conf_path)
      Context.new(conf_path)
      enter_loop
    end


    # registers a sidekick available to config files
    def register(name, &block)
      MethodProxy.register(name, block)
    end

    # registers a callback for timesharing between
    # active sidekicks
    def timeshare(&callback)
      @@timeshare << callback
    end

    # begins the timesharing loop
    def enter_loop
      Signal.trap :INT do
        exit
      end

      loop do
        @@timeshare.each {|blk| blk.call }
        sleep @@refresh
      end
    end

    # logs sidekick events. helpers should just call
    # the local log method instead.
    def log(str)
      puts str
    end

    # returns current platform: :linux, :darwin, :other
    def platform
      [:linux, :darwin].each do |plf|
        if Config::CONFIG['target_os'] =~ /#{plf}/i
          return plf
        end
      end
      other
    end
  end


  # A new Context is used to run the .sidekick
  # config file. It simply extends Module.
  class Context < ::Module
    def initialize(conf_path)
      super()
      extend MethodProxy
      extend Helpers
      code = open(conf_path) { |f| f.read }
      module_eval(code, conf_path)
    end
  end

  # New contexts also extend MethodProxy, so that
  # they can forward method calls to the registered
  # sidekicks.
  module MethodProxy
    @@actions = {}

    # registers a sidekick
    def self.register(name, block)
      @@actions[name] = block
    end

    def method_missing(name, *args, &blk)
      if @@actions[name]
        @@actions[name].call(blk, *args)
      else
        super
      end
    end

    def respond_to?(method)
      super || !!@@actions[method]
    end
  end

end

require 'sidekick/helpers'
require 'sidekick/triggers'



