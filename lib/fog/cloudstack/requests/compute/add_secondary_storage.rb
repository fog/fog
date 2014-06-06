module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds secondary storage.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addSecondaryStorage.html]
        def add_secondary_storage(url, options={})
          options.merge!(
            'command' => 'addSecondaryStorage', 
            'url' => url  
          )
          request(options)
        end
      end

    end
  end
end

