module Fog
  module Compute
    class Cloudstack

      class Real
        # Retrieves a cloud identifier.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/getCloudIdentifier.html]
        def get_cloud_identifier(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'getCloudIdentifier') 
          else
            options.merge!('command' => 'getCloudIdentifier', 
            'userid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

