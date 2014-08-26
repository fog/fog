module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates resource tag(s)
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createTags.html]
        def create_tags(options={})
          request(options)
        end


        def create_tags(tags, resourcetype, resourceids, options={})
          options.merge!(
            'command' => 'createTags', 
            'tags' => tags, 
            'resourcetype' => resourcetype, 
            'resourceids' => resourceids  
          )
          request(options)
        end
      end

    end
  end
end

