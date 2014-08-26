module Fog
  module Compute
    class Cloudstack

      class Real
        # list portable IP ranges
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listPortableIpRanges.html]
        def list_portable_ip_ranges(options={})
          options.merge!(
            'command' => 'listPortableIpRanges'  
          )
          request(options)
        end
      end

    end
  end
end

