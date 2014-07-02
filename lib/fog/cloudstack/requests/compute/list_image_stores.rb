module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists image stores.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listImageStores.html]
        def list_image_stores(options={})
          options.merge!(
            'command' => 'listImageStores'  
          )
          request(options)
        end
      end

    end
  end
end

