module Fog
  module Compute
    class Cloudstack

      class Real
        # List resource detail(s)
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listResourceDetails.html]
        def list_resource_details(options={})
          options.merge!(
            'command' => 'listResourceDetails'  
          )
          request(options)
        end
      end

    end
  end
end

