require 'fog/core/collection'
require 'fog/cloudstack/models/compute/flavor'

module Fog
  module Compute
    class Cloudstack

      class Flavors < Fog::Collection

        model Fog::Compute::Cloudstack::Flavor

        def all
          data = connection.list_service_offerings["listserviceofferingsresponse"]["serviceoffering"] || []
          load(data)
        end

        def get(flavor_id)
          if flavor = connection.list_service_offerings('id' => flavor_id)["listserviceofferingsresponse"]["serviceoffering"].first
            new(flavor)
          end
        rescue Fog::Compute::Cloudstack::BadRequest
          nil
        end
      end

    end
  end
end
