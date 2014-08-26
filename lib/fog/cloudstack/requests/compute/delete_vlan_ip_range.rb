module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a VLAN IP range.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteVlanIpRange.html]
        def delete_vlan_ip_range(id, options={})
          options.merge!(
            'command' => 'deleteVlanIpRange', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

