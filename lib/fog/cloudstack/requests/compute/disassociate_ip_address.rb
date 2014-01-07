module Fog
  module Compute
    class Cloudstack
      class Real

        # Disassociate an ip address.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/disassociateIpAddress.html]
        def disassociate_ip_address(options={})
          options.merge!(
              'command' => 'disassociateIpAddress'
          )

          request(options)
        end

      end

      class Mock

        # Disassociate an ip address mock.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/disassociateIpAddress.html]
        def disassociate_ip_address(options={})
          { 'disassociateipaddressresponse' =>
                { 'count' => 2,
                  'disassociate_info' => {
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
