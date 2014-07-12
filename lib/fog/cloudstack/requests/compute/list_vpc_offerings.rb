module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists VPC offerings
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listVPCOfferings.html]
        def list_vpc_offerings(options={})
          options.merge!(
            'command' => 'listVPCOfferings'  
          )
          request(options)
        end
      end

    end
  end
end

