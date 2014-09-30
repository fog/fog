module Fog
  module Compute
    class Cloudstack

      class Real
        # Suspends a project
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/suspendProject.html]
        def suspend_project(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'suspendProject') 
          else
            options.merge!('command' => 'suspendProject', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

