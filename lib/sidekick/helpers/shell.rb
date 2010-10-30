
module Sidekick::Helpers::Shell

  def sh(cmd)
    log cmd
    puts result = `#{cmd}`
    result
  end

end
