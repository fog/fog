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
            'endip' => options['endip'], 
            'netmask' => options['netmask'], 
            'gateway' => options['gateway'], 
            'regionid' => options['regionid'], 
            'startip' => options['startip'], 
             
          )
          request(options)
        end
      end

    end
  end
end

