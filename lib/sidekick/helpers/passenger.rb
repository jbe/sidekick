




module Sidekick::Helpers::Passenger

  def restart_passenger
    FileUtils.touch './tmp/restart.txt'
    log 'restarted passenger'
  end


end
