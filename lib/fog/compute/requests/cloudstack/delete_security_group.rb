module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates an account.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/deleteSecurityGroup.html]
        def delete_security_group(options={})
          options.merge!(
            'command' => 'deleteSecurityGroup'
          )

          request(options)
        end

      end
    end
  end
end
