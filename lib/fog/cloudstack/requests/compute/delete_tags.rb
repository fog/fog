module Fog
  module Compute
    class Cloudstack

      class Real
        # Deleting resource tag(s)
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteTags.html]
        def delete_tags(resourceids, resourcetype, options={})
          options.merge!(
            'command' => 'deleteTags', 
            'resourceids' => resourceids, 
            'resourcetype' => resourcetype  
          )
          request(options)
        end
      end

    end
  end
end

