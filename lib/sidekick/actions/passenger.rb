




module Sidekick::Actions::Passenger

  def restart_passenger
    FileUtils.touch './tmp/restart.txt'
    log 'restarted passenger'
  end

  def passenger_server(port=3000)
    sh "passenger start -d -p #{port.to_s}"
    on_stop { sh "passenger stop -p #{port.to_s}" }
  end

end
