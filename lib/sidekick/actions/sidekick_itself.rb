
module Sidekick::Actions::SidekickItself

  def log(str)
    puts ' -> ' + str
  end

  def log_trigger(str)
    puts str
  end

  def stop(*prms)
    ::Sidekick.stop(*prms)
  end

end
