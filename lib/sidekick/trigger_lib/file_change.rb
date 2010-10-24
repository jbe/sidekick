


module Sidekick::Triggers::FileChange

  def self.new(*args)
    case platform
      when :linux then Polling
      when :darwin then Polling
      else Polling
    end.new(*args)
  end



  class Polling

    def initialize(glob, ignore_first=false, &callback)
      log "polling #{glob} for file changes.."
      @path = glob
      @file_timestamps = {}
      @callback = callback
      changes if ignore_first # prebuild cache
    end

    def poll
      unless (c = changes).empty?
        Sidekick.log "watch #{changes.inspect}"
        @callback.call(c)
      end
    end

    def changes
      r = []
      Dir[@path].each do |path|
        mtime = File.new('./' + path).mtime
        unless @file_timestamps[path] == mtime
          r << path
          @file_timestamps[path] = mtime
        end
      end
    end
  end


end


