
 # Basically, the job of a trigger definition is to take the parameters and the block from a directive in the `.sidekick` file, and then hook into EventMachine in some way to set up the trigger.
module Sidekick::Actions::Triggers


  def watch(*globs)
    needs 'em-dir-watcher', 'to watch file changes'

    EMDirWatcher.watch(
      File.expand_path('.'),
      :include_only => globs,
      :grace_period => 0.2
      ) do |paths|
      log_trigger "watch #{paths.inspect}"
      yield(paths)
    end
  end

  def every(duration)
    EventMachine::PeriodicTimer.new(duration) do
      log_trigger "every #{duration} seconds"
      yield
    end
  end

  def after(duration)
    EventMachine::Timer.new(duration) do
      log_trigger "after #{duration} seconds"
      yield
    end
  end

  def on_start(&blk)
    after(0, &blk)
  end

  def on_stop(&blk)
    ::Sidekick::STOP_CALLBACKS << blk
  end

end


