module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all Pods.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listPods.html]
        def list_pods(options={})
          options.merge!(
            'command' => 'listPods'  
          )
          request(options)
        end
      end

    end
  end
end

