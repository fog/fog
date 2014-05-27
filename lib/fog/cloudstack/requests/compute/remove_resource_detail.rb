module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes detail for the Resource.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/removeResourceDetail.html]
        def remove_resource_detail(options={})
          options.merge!(
            'command' => 'removeResourceDetail', 
            'resourceid' => options['resourceid'], 
            'resourcetype' => options['resourcetype']  
          )
          request(options)
        end
      end

    end
  end
end

