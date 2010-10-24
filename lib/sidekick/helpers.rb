
# default helpers

module Sidekick::Helpers

  # action logger. sidekicks should use Sidekick.log instead.

  def log(str)
    puts ' -> ' + str
  end

  def restart_passenger
    require 'fileutils'
    FileUtils.touch './tmp/restart.txt'
    log 'Restart passenger'
  end
end
