module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a project
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createProject.html]
        def create_project(options={})
          options.merge!(
            'command' => 'createProject', 
            'name' => options['name'], 
            'displaytext' => options['displaytext']  
          )
          request(options)
        end
      end

    end
  end
end

