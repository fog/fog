module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicates a guest vlan range to an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/dedicateGuestVlanRange.html]
        def dedicate_guest_vlan_range(account, domainid, vlanrange, physicalnetworkid, options={})
          options.merge!(
            'command' => 'dedicateGuestVlanRange', 
            'account' => account, 
            'domainid' => domainid, 
            'vlanrange' => vlanrange, 
            'physicalnetworkid' => physicalnetworkid  
          )
          request(options)
        end
      end

    end
  end
end

