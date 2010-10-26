

require 'em-dir-watcher'


module Sidekick::Triggers

  # default triggers

  register :watch do |callback, glob|
    EMDirWatcher.watch(
      File.expand_path('.'),
      :include_only => [glob],
      :grace_period => 0.2,
      ) do |paths|
        log "watch #{paths.inspect}"
        callback.call(paths)
      end
  end

  register :every do |callback, duration|
    EventMachine::PeriodicTimer.new(duration) do
      log "every #{duration} seconds"
      callback.call
    end
  end

end



