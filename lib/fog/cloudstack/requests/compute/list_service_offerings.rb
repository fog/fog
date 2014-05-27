module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all available service offerings.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listServiceOfferings.html]
        def list_service_offerings(options={})
          options.merge!(
            'command' => 'listServiceOfferings'  
          )
          request(options)
        end
      end
 
      class Mock

        def list_service_offerings(options={})
          flavors = []
          if service_offering_id = options['id']
            flavor = self.data[:flavors][service_offering_id]
            raise Fog::Compute::Cloudstack::BadRequest unless flavor
            flavors = [flavor]
          else
            flavors = self.data[:flavors].values
          end

          {
            "listserviceofferingsresponse" =>
            {
              "count" => flavors.size,
              "serviceoffering"=> flavors
            }
          }
        end
      end 
    end
  end
end

