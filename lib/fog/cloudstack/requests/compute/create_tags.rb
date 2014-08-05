module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates resource tag(s)
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createTags.html]
        def create_tags(resourceids, resourcetype, tags, options={})
          options.merge!(
            'command' => 'createTags', 
            'resourceids' => resourceids, 
            'resourcetype' => resourcetype, 
            'tags' => tags  
          )
          request(options)
        end
      end

    end
  end
end

