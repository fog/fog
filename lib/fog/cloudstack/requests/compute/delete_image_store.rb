module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes an image store .
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteImageStore.html]
        def delete_image_store(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteImageStore') 
          else
            options.merge!('command' => 'deleteImageStore', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

