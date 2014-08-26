module Fog
  module Compute
    class Cloudstack

      class Real
        # adds a range of portable public IP's to a region
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createPortableIpRange.html]
        def create_portable_ip_range(options={})
          request(options)
        end


        def create_portable_ip_range(startip, netmask, regionid, gateway, endip, options={})
          options.merge!(
            'command' => 'createPortableIpRange', 
            'startip' => startip, 
            'netmask' => netmask, 
            'regionid' => regionid, 
            'gateway' => gateway, 
            'endip' => endip  
          )
          request(options)
        end
      end

    end
  end
end

