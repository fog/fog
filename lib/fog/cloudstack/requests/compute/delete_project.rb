module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a project
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteProject.html]
        def delete_project(id, options={})
          options.merge!(
            'command' => 'deleteProject', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

