module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists image stores.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listImageStores.html]
        def list_image_stores(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listImageStores') 
          else
            options.merge!('command' => 'listImageStores')
          end
          request(options)
        end
      end

    end
  end
end

