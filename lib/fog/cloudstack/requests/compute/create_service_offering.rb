module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a service offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createServiceOffering.html]
        def create_service_offering(options={})
          request(options)
        end


        def create_service_offering(name, displaytext, options={})
          options.merge!(
            'command' => 'createServiceOffering', 
            'name' => name, 
            'displaytext' => displaytext  
          )
          request(options)
        end
      end

    end
  end
end

