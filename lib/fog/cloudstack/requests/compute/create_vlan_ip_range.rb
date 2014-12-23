module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a VLAN IP range.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createVlanIpRange.html]
        def create_vlan_ip_range(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createVlanIpRange') 
          else
            options.merge!('command' => 'createVlanIpRange')
          end
          request(options)
        end
      end
      class Mock
        def create_vlan_ip_range(options={})
          vlan_ip_ranges = self.data[:vlan_ip_ranges]
          { 'createvlaniprangeresponse' =>
                { 'count' => vlan_ip_ranges.count,
                  'vlan_ip_ranges' => vlan_ip_ranges
                }
          }
        end
      end

    end
  end
end

