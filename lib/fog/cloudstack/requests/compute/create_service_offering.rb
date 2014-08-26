module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a service offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createServiceOffering.html]
        def create_service_offering(displaytext, cpunumber, name, memory, cpuspeed, options={})
          options.merge!(
            'command' => 'createServiceOffering', 
            'displaytext' => displaytext, 
            'cpunumber' => cpunumber, 
            'name' => name, 
            'memory' => memory, 
            'cpuspeed' => cpuspeed  
          )
          request(options)
        end
      end

    end
  end
end

