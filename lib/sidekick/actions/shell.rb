
module Sidekick::Actions::Shell

  def sh(cmd)
    log cmd; `#{cmd}`
  end

end
