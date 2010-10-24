require 'fileutils'
require 'rbconfig'


# default helpers

module Sidekick::Helpers

  module Util
    # :linux, :darwin, :other
    def platform
      [:linux, :darwin].each do |plf|
        return plf if Config::CONFIG['target_os'] =~ /#{plf}/i
      end; :other
    end

    def running?(plf)
      plf == platform
    end

    def gem_load?(gemname)
      @installed ||= begin
        require gemname
        true
      rescue LoadError
        puts "Please install the #{gemname} gem to enable all functions."
        false
      end
    end
  end

  include Util
  extend Util

  module Notification
    extend ::Sidekick::Helpers::Util
    def self.show(message, title='Sidekick')
      if running?(:linux) and gem_load?('libnotify')
        Libnotify.show :body => message, :summary => title
      elsif running?(:darwin) and gem_load?('growl')
        Growl.notify message, :title => title, :name => 'Sidekick'
      else
        puts "Notification: #{title} #{message}"
      end
    end
  end



  def log(str)
    puts ' -> ' + str
  end

  def notify(*args)
    Notification.show(*args)
  end

  def sh(cmd)
    log cmd
    puts `#{cmd}`
  end
  


  def restart_passenger
    FileUtils.touch './tmp/restart.txt'
    log 'restarted passenger'
  end

end
