module Fog
  module Compute
    class Cloudstack

      class Real
        # List network devices
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listNetworkDevice.html]
        def list_network_device(options={})
          options.merge!(
            'command' => 'listNetworkDevice'  
          )
          request(options)
        end
      end

    end
  end
end

