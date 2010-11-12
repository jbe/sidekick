

module Sidekick::Actions::Compile

  # Compiles one template using the `tilt` gem.

  def compile(source, target)
    needs 'tilt', 'to compile templates'
    handling Exception, source do
      File.open(target, 'w') do |f|
        f.write(Tilt.new(source).render)
      end
    end
  end


  # watches for changes matching the `source` glob, and compiles to `target`, replacing ':name' in `target` with the basename of the changed file.
  def auto_compile(source, target)

    watch(source) do |files|
      files.each do |file|
        if File.exists?(file)
            t = target.gsub(':name', File.basename(file, '.*'))
            compile file, t
            log "render #{file} => #{t}"
        end
      end
    end
  end

end
