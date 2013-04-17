module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a VLAN IP range.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/3.0.3/api_3.0.3/root_admin/createVlanIpRange.html]
        def create_vlan_ip_range(options={})
          options.merge!(
            'command' => 'createVlanIpRange'
          )
          request(options)
        end

      end
    end
  end
end
