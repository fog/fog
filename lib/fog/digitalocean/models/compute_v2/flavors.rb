module Fog
  module Compute
    class DigitalOceanV2
      class Flavors < Fog::Collection
        model Fog::Compute::DigitalOceanV2::Flavor

        # Retrieves flavours (aka. sizes)
        # @return [Fog::Compute::DigitalOceanV2:Flavor]
        # @raise [Fog::Compute::DigitalOceanV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::DigitalOceanV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::DigitalOceanV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::DigitalOceanV2::ServiceError]
        # @see https://developers.digitalocean.com/documentation/v2/#list-all-sizes
        def all(filters = {})
          data = service.list_flavors.body["sizes"]
          load(data)
        end
      end
    end
  end
end