module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes detail for the Resource.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/removeResourceDetail.html]
        def remove_resource_detail(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'removeResourceDetail') 
          else
            options.merge!('command' => 'removeResourceDetail', 
            'resourcetype' => args[0], 
            'resourceid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

