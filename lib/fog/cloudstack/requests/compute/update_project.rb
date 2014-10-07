module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a project
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateProject.html]
        def update_project(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateProject') 
          else
            options.merge!('command' => 'updateProject', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

