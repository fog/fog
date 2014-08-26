module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes specified region
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/removeRegion.html]
        def remove_region(id, options={})
          options.merge!(
            'command' => 'removeRegion', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

