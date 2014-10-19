module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes network device.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteNetworkDevice.html]
        def delete_network_device(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteNetworkDevice') 
          else
            options.merge!('command' => 'deleteNetworkDevice', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

