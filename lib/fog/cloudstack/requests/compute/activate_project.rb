module Fog
  module Compute
    class Cloudstack

      class Real
        # Activates a project
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/activateProject.html]
        def activate_project(id, options={})
          options.merge!(
            'command' => 'activateProject', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

