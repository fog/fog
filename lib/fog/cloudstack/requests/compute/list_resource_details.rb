module Fog
  module Compute
    class Cloudstack

      class Real
        # List resource detail(s)
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listResourceDetails.html]
        def list_resource_details(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listResourceDetails') 
          else
            options.merge!('command' => 'listResourceDetails', 
            'resourcetype' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

