module Fog
  module Compute
    class Cloudstack

      class Real
        # adds a range of portable public IP's to a region
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createPortableIpRange.html]
        def create_portable_ip_range(endip, startip, gateway, netmask, regionid, options={})
          options.merge!(
            'command' => 'createPortableIpRange', 
            'endip' => endip, 
            'startip' => startip, 
            'gateway' => gateway, 
            'netmask' => netmask, 
            'regionid' => regionid  
          )
          request(options)
        end
      end

    end
  end
end

