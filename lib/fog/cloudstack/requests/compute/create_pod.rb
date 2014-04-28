module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a new Pod.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/3.0.3/api_3.0.3/root_admin/createPod.html]
        def create_pod(options={})
          options.merge!(
            'command' => 'createPod'
          )
          request(options)
        end

      end
    end
  end
end
