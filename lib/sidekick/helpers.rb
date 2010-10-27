require 'fileutils'
require 'rbconfig'
require 'tilt'


# default helpers

module Sidekick::Helpers

  # system

  require 'sidekick/helpers/util'
  include Util

  def log(str)
    puts ' -> ' + str
  end

  def stop(*prms)
    Sidekick.stop(*prms)
  end

  # notifications

  def notify(message, title='Sidekick')

    gems = {:linux => 'libnotify', :darwin => 'growl'}

    stop('Notifications not supported.') unless platform_load?(
                                          gems, 'notifications')
    case platform
      when :linux
        Libnotify.show :body => message, :summary => title
      when :darwin
        Growl.notify message, :title => title, :name => 'Sidekick'
    end
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
        if File.exists?(file)
          begin
            t = target.gsub(':name', File.basename(file, '.*'))
            File.open(t, 'w') do |f|
              f.write(Tilt.new(file).render)
            end
            log "render #{file} => #{t}"
          rescue Exception => e
            notify "Error in #{file}:\n#{e}"
            log    "Error in #{file}:\n#{e}"
          end
        end
      end
    end
  end

end
