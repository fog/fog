module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a region
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateRegion.html]
        def update_region(options={})
          options.merge!(
            'command' => 'updateRegion', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

