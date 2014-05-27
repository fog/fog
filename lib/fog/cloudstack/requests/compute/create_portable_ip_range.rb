module Fog
  module Compute
    class Cloudstack

      class Real
        # adds a range of portable public IP's to a region
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createPortableIpRange.html]
        def create_portable_ip_range(options={})
          options.merge!(
            'command' => 'createPortableIpRange', 
            'netmask' => options['netmask'], 
            'startip' => options['startip'], 
            'gateway' => options['gateway'], 
            'endip' => options['endip'], 
            'regionid' => options['regionid']  
          )
          request(options)
        end
      end

    end
  end
end

