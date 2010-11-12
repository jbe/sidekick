
module Sidekick::Actions::Rake

  def rake(task_name)
    needs 'rake', 'to invoke rake tasks'
    handling Exception, "rake #{task_name}" do
      load 'Rakefile'
      Rake::application[task_name].invoke
    end
  end

end
