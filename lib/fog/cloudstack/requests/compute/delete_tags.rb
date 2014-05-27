module Fog
  module Compute
    class Cloudstack

      class Real
        # Deleting resource tag(s)
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteTags.html]
        def delete_tags(options={})
          options.merge!(
            'command' => 'deleteTags', 
            'resourceids' => options['resourceids'], 
            'resourcetype' => options['resourcetype']  
          )
          request(options)
        end
      end

    end
  end
end

