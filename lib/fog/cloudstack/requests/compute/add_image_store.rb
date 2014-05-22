module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds backup image store.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addImageStore.html]
        def add_image_store(options={})
          options.merge!(
            'command' => 'addImageStore',
            'provider' => options['provider'], 
             
          )
          request(options)
        end
      end

    end
  end
end

