module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a project
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createProject.html]
        def create_project(displaytext, name, options={})
          options.merge!(
            'command' => 'createProject', 
            'displaytext' => displaytext, 
            'name' => name  
          )
          request(options)
        end
      end

    end
  end
end

