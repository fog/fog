module Fog
  module Compute
    class Cloudstack

      class Real
        # deletes a range of portable public IP's associated with a region
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deletePortableIpRange.html]
        def delete_portable_ip_range(options={})
          options.merge!(
            'command' => 'deletePortableIpRange',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

