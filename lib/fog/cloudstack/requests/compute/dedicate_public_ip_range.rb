module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicates a Public IP range to an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/dedicatePublicIpRange.html]
        def dedicate_public_ip_range(options={})
          request(options)
        end


        def dedicate_public_ip_range(domainid, account, id, options={})
          options.merge!(
            'command' => 'dedicatePublicIpRange', 
            'domainid' => domainid, 
            'account' => account, 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

