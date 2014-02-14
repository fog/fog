  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Acquires and associates a public IP to an account.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/associateIpAddress.html]
          def associate_ip_address(options={})
            options.merge!(
              'command' => 'associateIpAddress'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
