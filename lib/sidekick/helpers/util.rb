



module Util
  # :linux, :darwin, :other
  def platform
    [:linux, :darwin].each do |plf|
      return plf if Config::CONFIG['target_os'] =~ /#{plf}/i
    end; :other
  end

  def gem_load?(gemname, function='full')
    @installed ||= begin
      require gemname
      true
    rescue LoadError
      "Please gem install #{gemname} for #{function} support."
      ::Sidekick.stop
    end
  end

  def platform_load?(gems, function='full')
    gem_load?(gems[platform], function)
  end
end
