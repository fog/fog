module Fog
  module Compute
    class Cloudstack

      class Real
        # Dedicates a Public IP range to an account
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/dedicatePublicIpRange.html]
        def dedicate_public_ip_range(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'dedicatePublicIpRange') 
          else
            options.merge!('command' => 'dedicatePublicIpRange', 
            'domainid' => args[0], 
            'account' => args[1], 
            'id' => args[2])
          end
          request(options)
        end
      end

    end
  end
end

