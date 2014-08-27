module Fog
  module Compute
    class Cloudstack

      class Real
        # Releases a dedicated guest vlan range to the system
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/releaseDedicatedGuestVlanRange.html]
        def release_dedicated_guest_vlan_range(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'releaseDedicatedGuestVlanRange') 
          else
            options.merge!('command' => 'releaseDedicatedGuestVlanRange', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

