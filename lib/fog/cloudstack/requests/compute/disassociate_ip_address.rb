module Fog
  module Compute
    class Cloudstack

      class Real
        # Disassociates an ip address from the account.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/disassociateIpAddress.html]
        def disassociate_ip_address(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'disassociateIpAddress')
          else
            options.merge!('command' => 'disassociateIpAddress',
            'id' => args[0])
          end
          request(options)
        end
      end

      class Mock
        def disassociate_ip_address(*args)
          public_ip_address_id = args[0].is_a?(Hash) ? args[0]['id'] : args[0]
          if self.data[:public_ip_addresses][public_ip_address_id]
            self.data[:public_ip_addresses].delete(public_ip_address_id)
            { "disassociateipaddressresponse" => { "success" => "true" }}
          end
        end
      end

    end
  end
end

