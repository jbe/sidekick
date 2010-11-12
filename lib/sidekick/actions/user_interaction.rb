
module Sidekick::Actions::UserInteraction
  def notify(message, title='Sidekick')

    log "NOTIFY #{title}: #{message}"
    case platform
      when :linux
        needs 'libnotify', 'to display status messages on linux'
        Libnotify.show :body => message, :summary => title
      when :darwin
        needs 'growl', 'to display status messages on a Mac.'
        Growl.notify message, :title => title, :name => 'Sidekick'
    end
  end
end
