
module Sidekick::Helpers::SidekickItself

  def log(str)
    puts ' -> ' + str
  end

  def stop(*prms)
    ::Sidekick.stop(*prms)
  end

end
