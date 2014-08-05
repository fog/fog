module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a service offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteServiceOffering.html]
        def delete_service_offering(id, options={})
          options.merge!(
            'command' => 'deleteServiceOffering', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

