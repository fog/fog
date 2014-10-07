module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all available service offerings.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listServiceOfferings.html]
        def list_service_offerings(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listServiceOfferings') 
          else
            options.merge!('command' => 'listServiceOfferings')
          end
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

