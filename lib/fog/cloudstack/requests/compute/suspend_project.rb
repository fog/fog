module Fog
  module Compute
    class Cloudstack

      class Real
        # Suspends a project
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/suspendProject.html]
        def suspend_project(options={})
          options.merge!(
            'command' => 'suspendProject', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

