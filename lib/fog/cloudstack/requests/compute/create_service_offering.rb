module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a service offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createServiceOffering.html]
        def create_service_offering(options={})
          options.merge!(
            'command' => 'createServiceOffering', 
            'cpuspeed' => options['cpuspeed'], 
            'displaytext' => options['displaytext'], 
            'name' => options['name'], 
            'cpunumber' => options['cpunumber'], 
            'memory' => options['memory']  
          )
          request(options)
        end
      end

    end
  end
end

