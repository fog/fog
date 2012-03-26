module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists all Pods.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listPods.html]
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
