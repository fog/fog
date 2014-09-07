module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a service offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createServiceOffering.html]
        def create_service_offering(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createServiceOffering') 
          else
            options.merge!('command' => 'createServiceOffering', 
            'name' => args[0], 
            'displaytext' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

