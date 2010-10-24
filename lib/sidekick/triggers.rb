

module Sidekick::Triggers

  # registers a class conforming to the sidekick
  # trigger class api
  def self.register_class(keyword, kls)
    register(keyword) do |*prms|
      o = kls.new(*prms)
      timeshare { o.poll } if o.respond_to? :poll
    end
  end

  # default triggers

  require 'sidekick/triggers/watch'

  register_class(:watch, Watch)
  
  register :every do |callback, duration|
    timeshare(duration) do
      callback.call
    end
  end

end



