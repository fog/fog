module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a VLAN IP range.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteVlanIpRange.html]
        def delete_vlan_ip_range(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteVlanIpRange') 
          else
            options.merge!('command' => 'deleteVlanIpRange', 
            'id' => args[0])
          end
          request(options)
        end
      end

      class Mock
        
        # Deletes a VLAN IP range.
        #
        # {CloudStack API Reference}[http://incubator.apache.org/cloudstack/docs/api/apidocs-4.0.0/root_admin/deleteVlanIpRange.html]
        def delete_vlan_ip_range(options={})
        { 'deletevlaniprangeresponse' =>
          {
              'count' => 2,
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

