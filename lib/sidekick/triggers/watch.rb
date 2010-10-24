
require 'rbconfig'

module Sidekick::Triggers::Watch

  def self.new(*args)
    case platform
      when :linux then Polling
      when :darwin then Polling
      else Polling
    end.new(*args)
  end

  # returns current platform: :linux, :darwin, :other
  def self.platform
    [:linux, :darwin].each do |plf|
        Config::CONFIG['target_os'] =~ /#{plf}/i ? plf : :other
    end
  end

  class Polling

    def initialize(callback, glob, ignore_first=false)
      puts callback.inspect
      ::Sidekick::Triggers.log "polling #{glob} for file changes.."
      @path = glob
      @file_timestamps = {}
      @callback = callback
      read_changes if ignore_first # prebuild cache
    end

    def poll
      if changed?
        ::Sidekick::Triggers.log "watch #{@changes.inspect}"
        @callback.call(@changes)
      end
    end

    private

      def changed?
        read_changes
        !@changes.empty?
      end

      def read_changes
        @changes = []
        Dir[@path].each do |path|
          mtime = File.new('./' + path).mtime
          unless @file_timestamps[path] == mtime
            @changes << path
            @file_timestamps[path] = mtime
          end
        end
      end
  end

# TODO inotify and mac support



end
