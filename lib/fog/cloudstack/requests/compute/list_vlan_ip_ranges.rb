module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a Zone.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/3.0.3/api_3.0.3/root_admin/listVlanIpRanges.html]
        def list_vlan_ip_ranges(options={})
          options.merge!(
            'command' => 'listVlanIpRanges'
          )
          request(options)
        end

      end # Real
    end # Cloudstack
  end # Compute
end # Fog
