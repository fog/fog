module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicates a guest vlan range to an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/dedicateGuestVlanRange.html]
        def dedicate_guest_vlan_range(options={})
          options.merge!(
            'command' => 'dedicateGuestVlanRange',
            'vlanrange' => options['vlanrange'], 
            'domainid' => options['domainid'], 
            'physicalnetworkid' => options['physicalnetworkid'], 
            'account' => options['account'], 
             
          )
          request(options)
        end
      end

    end
  end
end

