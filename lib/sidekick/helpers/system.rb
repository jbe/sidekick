
require 'rbconfig'



module Sidekick::Helpers::System
  def platform
    {
      :linux => /linux/,
      :darwin => /darwin/,
      :windows => /mswin|mingw|cygwin/
    }.each do |platform, regex|
      return platform if Config::CONFIG['host_os'] =~ regex
    end; :other
  end

  def gem_load?(gemname)
    begin
      require gemname
      true
    rescue LoadError; false; end
  end

  def needs(gem_name, reason)
    unless gem_load?(gem_name)
      ::Sidekick.stop "You must install the #{gem_name} gem #{reason}."
    end
  end

  def prefers(gem_name, reason)
    unless gem_load?(gem_name)
      log "Please install the #{gem_name} gem #{reason}."
    end
  end
end

