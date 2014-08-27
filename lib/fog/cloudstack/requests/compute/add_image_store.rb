module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds backup image store.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addImageStore.html]
        def add_image_store(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addImageStore') 
          else
            options.merge!('command' => 'addImageStore', 
            'provider' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

