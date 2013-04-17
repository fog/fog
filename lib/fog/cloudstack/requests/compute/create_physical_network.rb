module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a physical network
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/3.0.3/api_3.0.3/root_admin/createPhysicalNetwork.html]
        def create_physical_network(options={})
          options.merge!(
            'command' => 'createPhysicalNetwork'
          )
          request(options)
        end

      end # Real
    end # Cloudstack
  end # Compute
end # Fog
