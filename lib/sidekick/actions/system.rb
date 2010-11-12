
require 'rbconfig'



module Sidekick::Actions::System
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
      abort "You must install the #{gem_name} gem #{reason}."
    end
  end

  def prefers(gem_name, reason)
    unless gem_load?(gem_name)
      log "Please install the #{gem_name} gem #{reason}."
    end
  end

  def handling(err_kls=Exception, context=nil)
    begin
      yield
    rescue err_kls => e
      if context
        notify "#{context}:\n#{e}", e.class.name
      else
        notify "#{e}\n#{e.backtrace[0..2]}", e.class.name
      end
    end
  end
end

