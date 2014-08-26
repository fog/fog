module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists dedicated pods.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listDedicatedPods.html]
        def list_dedicated_pods(options={})
          options.merge!(
            'command' => 'listDedicatedPods'  
          )
          request(options)
        end
      end

    end
  end
end

