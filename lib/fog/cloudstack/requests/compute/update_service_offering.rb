module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a service offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateServiceOffering.html]
        def update_service_offering(options={})
          options.merge!(
            'command' => 'updateServiceOffering',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

