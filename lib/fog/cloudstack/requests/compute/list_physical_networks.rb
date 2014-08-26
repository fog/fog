module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists physical networks
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listPhysicalNetworks.html]
        def list_physical_networks(options={})
          options.merge!(
            'command' => 'listPhysicalNetworks'  
          )
          request(options)
        end
      end

    end
  end
end

