module Fog
  module Compute
    class Cloudstack

      class Real
        # deletes a range of portable public IP's associated with a region
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deletePortableIpRange.html]
        def delete_portable_ip_range(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deletePortableIpRange') 
          else
            options.merge!('command' => 'deletePortableIpRange', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

