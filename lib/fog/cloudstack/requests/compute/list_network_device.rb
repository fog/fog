module Fog
  module Compute
    class Cloudstack

      class Real
        # List network devices
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listNetworkDevice.html]
        def list_network_device(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listNetworkDevice') 
          else
            options.merge!('command' => 'listNetworkDevice')
          end
          request(options)
        end
      end

    end
  end
end

