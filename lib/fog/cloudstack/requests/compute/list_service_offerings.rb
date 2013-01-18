module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists all available service offerings.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listServiceOfferings.html]
        def list_service_offerings(options={})
          options.merge!(
            'command' => 'listServiceOfferings'
          )

          request(options)
        end

      end # Real

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
      end # Mock
    end # Cloudstack
  end # Compute
end # Fog
