module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a Zone.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateZone.html]
        def update_zone(options={})
          options.merge!(
            'command' => 'updateZone', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

