module Fog
  module Compute
    class Cloudstack

      class Real
        # Retrieves a cloud identifier.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/getCloudIdentifier.html]
        def get_cloud_identifier(userid, options={})
          options.merge!(
            'command' => 'getCloudIdentifier', 
            'userid' => userid  
          )
          request(options)
        end
      end

    end
  end
end

