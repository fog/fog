  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Adds a network device of one of the following types: ExternalDhcp, ExternalFirewall, ExternalLoadBalancer, PxeServer
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/addNetworkDevice.html]
          def add_network_device(options={})
            options.merge!(
              'command' => 'addNetworkDevice'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
