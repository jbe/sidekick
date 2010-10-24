

module Sidekick::Triggers

  require 'sidekick/triggers/file_change'



  register(:watch) do |callback, glob|
    fc = FileChange.new(glob, &callback)
    timeshare { fc.poll } if fc.respond_to? :poll
  end


end



