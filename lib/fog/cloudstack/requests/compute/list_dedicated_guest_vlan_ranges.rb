module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists dedicated guest vlan ranges
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listDedicatedGuestVlanRanges.html]
        def list_dedicated_guest_vlan_ranges(options={})
          options.merge!(
            'command' => 'listDedicatedGuestVlanRanges'  
          )
          request(options)
        end
      end

    end
  end
end

