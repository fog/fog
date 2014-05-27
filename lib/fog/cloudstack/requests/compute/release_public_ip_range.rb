module Fog
  module Compute
    class Cloudstack

      class Real
        # Releases a Public IP range back to the system pool
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/releasePublicIpRange.html]
        def release_public_ip_range(options={})
          options.merge!(
            'command' => 'releasePublicIpRange', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

