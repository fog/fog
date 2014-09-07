module Fog
  module Compute
    class Cloudstack

      class Real
        # Activates a project
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/activateProject.html]
        def activate_project(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'activateProject') 
          else
            options.merge!('command' => 'activateProject', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

