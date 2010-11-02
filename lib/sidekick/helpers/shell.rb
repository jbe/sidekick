
module Sidekick::Helpers::Shell

  def sh(cmd)
    log cmd; `#{cmd}`
  end

end
