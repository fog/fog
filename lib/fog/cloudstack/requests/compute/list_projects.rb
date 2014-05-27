module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists projects and provides detailed information for listed projects
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listProjects.html]
        def list_projects(options={})
          options.merge!(
            'command' => 'listProjects'  
          )
          request(options)
        end
      end

    end
  end
end

