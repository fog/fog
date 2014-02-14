  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists all VLAN IP ranges.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listVlanIpRanges.html]
          def list_vlan_ip_ranges(options={})
            options.merge!(
              'command' => 'listVlanIpRanges'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
