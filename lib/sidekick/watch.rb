
module Sidekick::Watch; end

class Sidekick::Watch::FSObserver
  def initialize(glob, ignore_first=false)
    @path = glob
    @file_timestamps = {}
    changed if ignore_first # build cache first
  end

  def changed
    r = []
    Dir[@path].each do |path|
      mtime = File.new('./' + path).mtime
      unless @file_timestamps[path] == mtime
        r << path
        @file_timestamps[path] = mtime
      end
    end; r
  end
end




Sidekick.register(:watch) do |callback, glob|
  fs = Sidekick::Watch::FSObserver.new(glob)

  Sidekick.timeshare do
    unless (changes = fs.changed).empty?
      Sidekick.log "watch #{changes.inspect}"
      callback.call(changes)
    end
  end
end
