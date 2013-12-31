module Fog
  module Compute
    class Cloudstack
      class Real

        # Deletes a VLAN IP range.
        #
        # {CloudStack API Reference}[http://incubator.apache.org/cloudstack/docs/api/apidocs-4.0.0/root_admin/deleteVlanIpRange.html]
        def delete_vlan_ip_range(options={})
          options.merge!(
              'command' => 'deleteVlanIpRange'
          )

          request(options)
        end

      end

      class Mock

        # Deletes a VLAN IP range.
        #
        # {CloudStack API Reference}[http://incubator.apache.org/cloudstack/docs/api/apidocs-4.0.0/root_admin/deleteVlanIpRange.html]
        def delete_vlan_ip_range(options={})
          { 'deletevlaniprangeresponse' =>
                { 'count' => 2,
                  'delete_info' => {
                     'displaytext' => 'displaytext',
                     'success'     => true
                  }
                }
          }
        end
      end
    end
  end
end
