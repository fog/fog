module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a service offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateServiceOffering.html]
        def update_service_offering(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateServiceOffering') 
          else
            options.merge!('command' => 'updateServiceOffering', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

