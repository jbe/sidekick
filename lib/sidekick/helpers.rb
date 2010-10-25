require 'fileutils'
require 'rbconfig'
require 'tilt'


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
    puts result = `#{cmd}`
    result
  end



  def restart_passenger
    FileUtils.touch './tmp/restart.txt'
    log 'restarted passenger'
  end




  # watches for changes matching the source glob,
  # compiles using the tilt gem, and saves to
  # target. Target is interpolated for :name
  def auto_compile(source, target)
    watch(source) do |files|
      files.each do |file|
        begin
          target.gsub! ':name', File.basename(file, '.*')
          File.open(target, 'w') do |f|
            f.write(Tilt.new(file).render)
          end
          log "rendered #{file} => #{target}"
        rescue Exception => e
          notify "Error in #{file}:\n#{e}"
        end
      end
    end
  end




end
