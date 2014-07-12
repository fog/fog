module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicates a Public IP range to an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/dedicatePublicIpRange.html]
        def dedicate_public_ip_range(domainid, id, account, options={})
          options.merge!(
            'command' => 'dedicatePublicIpRange', 
            'domainid' => domainid, 
            'id' => id, 
            'account' => account  
          )
          request(options)
        end
      end

    end
  end
end

