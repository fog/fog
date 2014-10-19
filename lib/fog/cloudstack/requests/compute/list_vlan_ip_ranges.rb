module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all VLAN IP ranges.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listVlanIpRanges.html]
        def list_vlan_ip_ranges(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listVlanIpRanges') 
          else
            options.merge!('command' => 'listVlanIpRanges')
          end
          request(options)
        end
      end

    end
  end
end

