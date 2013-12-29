module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a VLAN IP range.
        #
        # {CloudStack API Reference}[http://incubator.apache.org/cloudstack/docs/api/apidocs-4.0.0/root_admin/createVlanIpRange.html]
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

