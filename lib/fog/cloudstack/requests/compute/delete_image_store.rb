module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes an image store .
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteImageStore.html]
        def delete_image_store(id, options={})
          options.merge!(
            'command' => 'deleteImageStore', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

