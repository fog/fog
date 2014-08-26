module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all public ip addresses
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listPublicIpAddresses.html]
        def list_public_ip_addresses(options={})
          options.merge!(
            'command' => 'listPublicIpAddresses'  
          )
          request(options)
        end
      end

    end
  end
end

