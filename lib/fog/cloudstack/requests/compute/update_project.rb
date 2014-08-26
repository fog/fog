module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a project
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateProject.html]
        def update_project(options={})
          request(options)
        end


        def update_project(id, options={})
          options.merge!(
            'command' => 'updateProject', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

