

module Sidekick::Actions::Compile

  # write a file to disk
  def write_file(path, data)
    File.open(path, 'w') {|f| f.write(data) }
  end

  # Compile a template using the `tilt` gem.
  def compile(source, target)
    needs 'tilt', 'to compile templates'
    handling Exception, source do
      write_file target, Tilt.new(source).render
    end
  end

  # compress a file using a suitable compressor for that
  # file type.
  def compress(source, target, opts={})
    handling Exception, source do
      case fmt = source.match(/\.[^\.]+$/).to_s
        when '.js'
          needs 'uglifier', 'to compress javascript'
          write_file target, Uglifier.new(opts).compile(File.read(source))
        else raise "Does not know how to compress #{fmt} files."
      end
    end
  end

  # Concatenate a bunch of files, preserving order
  def concat(target, *sources)
    write_file target, sources.map {|p| File.read(p) }.join("\n")
  end


  # watches for changes matching the `source` glob, and compiles to
  # `target`, replacing ':name' in `target` with the basename of the
  # changed file.
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



  # Watch for changes to several source files, concatenating to `target_base.concat.type`
  # and then compressing as per file type.
  def auto_compress(target, *sources)
    fmt      = target.match(/\.[^\.]+$/).to_s
    cat_path = target.sub(/#{fmt}$/, '.concat' + fmt)

    watch(*sources) do |files|
      concat(cat_path, *sources)
      compress(cat_path, target)
      log "compress => #{target}"
    end
  end


end
