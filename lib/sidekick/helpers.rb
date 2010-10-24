require 'fileutils'

# default helpers

module Sidekick::Helpers

  def log(str)
    puts ' -> ' + str
  end

  def restart_passenger
    FileUtils.touch './tmp/restart.txt'
    log 'Restart passenger'
  end
end
