module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds detail for the Resource.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addResourceDetail.html]
        def add_resource_detail(resourcetype, details, resourceid, options={})
          options.merge!(
            'command' => 'addResourceDetail', 
            'resourcetype' => resourcetype, 
            'details' => details, 
            'resourceid' => resourceid  
          )
          request(options)
        end
      end

    end
  end
end

