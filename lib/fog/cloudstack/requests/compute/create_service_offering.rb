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
            'displaytext' => options['displaytext'], 
            'memory' => options['memory'], 
            'cpuspeed' => options['cpuspeed'], 
            'name' => options['name'], 
            'cpunumber' => options['cpunumber'], 
             
          )
          request(options)
        end
      end

    end
  end
end

