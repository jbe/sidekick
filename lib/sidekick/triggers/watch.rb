

module Sidekick::Triggers::Watch

  def self.new(*args)

    name, adapter_class = {
      :linux    => [nil,  Polling], # Ready to implement fs-event
      :darwin   => [nil,  Polling], # and libnotify. Polling seems
      :other    => [nil,  Polling]  # to work perfectly though.
      }[::Sidekick::Helpers.platform]

    unless name.nil?
      adapter_class = Polling unless Sidekick::Helpers.load_gem?(name)
    end
    adapter_class.new(*args)
  end

  class Polling # todo: check for deletion

    def initialize(callback, glob, ignore_first=false)
      ::Sidekick::Triggers.log "polling #{glob} for file changes.."
      @path = glob
      @file_timestamps = {}
      @callback = callback
      read_changes if ignore_first # prebuild cache
    end

    def poll
      if changed?
        ::Sidekick::Triggers.log "file change #{@changes.inspect}"
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
        Dir.glob(@path).each do |path|
          mtime = File.new('./' + path).mtime
          unless @file_timestamps[path] == mtime
            @changes << path
            @file_timestamps[path] = mtime
          end
        end
      end
  end

end
