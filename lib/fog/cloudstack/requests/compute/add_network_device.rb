module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a network device of one of the following types: ExternalDhcp, ExternalFirewall, ExternalLoadBalancer, PxeServer
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addNetworkDevice.html]
        def add_network_device(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addNetworkDevice') 
          else
            options.merge!('command' => 'addNetworkDevice')
          end
          request(options)
        end
      end

    end
  end
end

