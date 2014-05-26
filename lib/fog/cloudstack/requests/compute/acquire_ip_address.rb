module Fog
  module Compute
    class Cloudstack
      class Real
        # Creates an account.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/associateIpAddress.html]
        def acquire_ip_address(options={})
          options.merge!(
            'command' => 'associateIpAddress'
          )

          request(options)
        end
      end
    end
  end
end
