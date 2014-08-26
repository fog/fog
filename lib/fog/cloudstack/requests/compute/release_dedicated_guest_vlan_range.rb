module Fog
  module Compute
    class Cloudstack

      class Real
        # Releases a dedicated guest vlan range to the system
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/releaseDedicatedGuestVlanRange.html]
        def release_dedicated_guest_vlan_range(id, options={})
          options.merge!(
            'command' => 'releaseDedicatedGuestVlanRange', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

