module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists resource limits.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listPublicIpAddresses.html]
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


