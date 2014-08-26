module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes network device.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteNetworkDevice.html]
        def delete_network_device(id, options={})
          options.merge!(
            'command' => 'deleteNetworkDevice', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

