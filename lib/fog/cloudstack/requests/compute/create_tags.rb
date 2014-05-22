module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates resource tag(s)
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createTags.html]
        def create_tags(options={})
          options.merge!(
            'command' => 'createTags',
            'resourcetype' => options['resourcetype'], 
            'resourceids' => options['resourceids'], 
            'tags' => options['tags'], 
             
          )
          request(options)
        end
      end

    end
  end
end

