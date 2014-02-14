  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Disassociates an ip address from the account.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/disassociateIpAddress.html]
          def disassociate_ip_address(options={})
            options.merge!(
              'command' => 'disassociateIpAddress'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
