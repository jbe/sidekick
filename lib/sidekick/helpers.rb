

module Sidekick::Helpers

  Dir['sidekick/helpers/**.rb'].each do |path|
    load path
  end

  constants.each do |name|
    include const_get(name) if const_get(name).is_a?(Module)
  end

end
