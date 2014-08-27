module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists projects and provides detailed information for listed projects
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listProjects.html]
        def list_projects(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listProjects') 
          else
            options.merge!('command' => 'listProjects')
          end
          request(options)
        end
      end

    end
  end
end

