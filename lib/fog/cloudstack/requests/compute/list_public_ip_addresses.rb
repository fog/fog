module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all public ip addresses
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listPublicIpAddresses.html]
        def list_public_ip_addresses(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listPublicIpAddresses') 
          else
            options.merge!('command' => 'listPublicIpAddresses')
          end
          request(options)
        end
      end

    end
  end
end

