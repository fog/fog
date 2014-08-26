module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a Zone.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateZone.html]
        def update_zone(id, options={})
          options.merge!(
            'command' => 'updateZone', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

