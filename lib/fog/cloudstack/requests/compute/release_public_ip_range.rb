module Fog
  module Compute
    class Cloudstack

      class Real
        # Releases a Public IP range back to the system pool
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/releasePublicIpRange.html]
        def release_public_ip_range(id, options={})
          options.merge!(
            'command' => 'releasePublicIpRange', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

