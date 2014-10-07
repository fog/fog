module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicates a guest vlan range to an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/dedicateGuestVlanRange.html]
        def dedicate_guest_vlan_range(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'dedicateGuestVlanRange') 
          else
            options.merge!('command' => 'dedicateGuestVlanRange', 
            'account' => args[0], 
            'domainid' => args[1], 
            'vlanrange' => args[2], 
            'physicalnetworkid' => args[3])
          end
          request(options)
        end
      end

    end
  end
end

