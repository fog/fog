module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates an account.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/authorizeSecurityGroupIngress.html]
        def revoke_security_group_ingress(options={})
          options.merge!(
            'command' => 'revokeSecurityGroupIngress'
          )

          request(options)
        end

      end
    end
  end
end

