module Fog
  module Compute
    class Cloudstack

      class Real
        # list portable IP ranges
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listPortableIpRanges.html]
        def list_portable_ip_ranges(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listPortableIpRanges') 
          else
            options.merge!('command' => 'listPortableIpRanges')
          end
          request(options)
        end
      end

    end
  end
end

