module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists security groups.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listSecurityGroups.html]
        def list_security_groups(options={})
          options.merge!(
            'command' => 'listSecurityGroups'
          )
          
          request(options)
        end

      end
    end
  end
end
