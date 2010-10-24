

module Sidekick

  # creates a module wrapper, which in turn
  # evaluates the .sidekick config file within
  # its own scope
  def self.run!(conf_path='.sidekick')
    abort('No .sidekick file!') unless File.exists?(conf_path)
    Context.new(conf_path)
    Triggers.enter_loop
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

  # New contexts also extend MethodProxy, so that they
  # can forward method calls to the registered sidekicks.
  module MethodProxy
    @@triggers = {}

    # registers a trigger
    def self.register(name, block)
      @@triggers[name] = block
    end

    def method_missing(name, *args, &blk)
      if @@triggers[name]
        @@triggers[name].call(blk, *args)
      else
        super
      end
    end

    def respond_to?(method)
      super || !!@@triggers[method]
    end
  end

  # contains trigger helpers and logic to register
  # triggers, making them available in sidekick
  module Triggers
    @@timeshare_callbacks = []
    @@timeshare_frequencies = []

    class << self

      # registers a sidekick available to .sidekick files
      def register(name, &block)
        MethodProxy.register(name, block)
      end

      # registers a callback for timesharing between
      # active sidekicks
      def timeshare(freq=1, &callback)
        @@timeshare_callbacks << callback
        @@timeshare_frequencies << freq
      end

      # begins the timesharing loop
      def enter_loop
        log '                       ^  ^  ^  ^    '
        log ' == SIDEKICK ==    ^ ctrl-c to exit ^'
        log '                                     '
        Signal.trap :INT do
          exit
        end

        0.upto(1.0/0) do |n|
          0.upto(@@timeshare_callbacks.size - 1) do |i|
            if n % @@timeshare_frequencies[i] == 0
              @@timeshare_callbacks[i].call(n)
            end
          end
          sleep 1
        end
      end

      def log(str)
        puts str
      end

    end
  end
end

require 'sidekick/helpers'
require 'sidekick/triggers'

