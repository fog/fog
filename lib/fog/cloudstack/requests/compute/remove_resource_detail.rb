module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes detail for the Resource.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/removeResourceDetail.html]
        def remove_resource_detail(resourcetype, resourceid, options={})
          options.merge!(
            'command' => 'removeResourceDetail', 
            'resourcetype' => resourcetype, 
            'resourceid' => resourceid  
          )
          request(options)
        end
      end

    end
  end
end

