module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a service offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteServiceOffering.html]
        def delete_service_offering(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteServiceOffering')
          else
            options.merge!('command' => 'deleteServiceOffering',
            'id' => args[0])
          end
          request(options)
        end
      end

      class Mock
        def delete_service_offering(options={})
          service_offering_id = options['id']
          data[:favours].delete(service_offering_id) if data[:flavours][service_offering_id]

          { 'deleteserviceofferingresponse' => { 'success' => 'true' } }
        end
      end

    end
  end
end

