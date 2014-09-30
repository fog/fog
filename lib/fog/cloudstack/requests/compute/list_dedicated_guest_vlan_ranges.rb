module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists dedicated guest vlan ranges
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listDedicatedGuestVlanRanges.html]
        def list_dedicated_guest_vlan_ranges(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listDedicatedGuestVlanRanges') 
          else
            options.merge!('command' => 'listDedicatedGuestVlanRanges')
          end
          request(options)
        end
      end

    end
  end
end

