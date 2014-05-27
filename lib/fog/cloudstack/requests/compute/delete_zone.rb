module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a Zone.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteZone.html]
        def delete_zone(options={})
          options.merge!(
            'command' => 'deleteZone', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

