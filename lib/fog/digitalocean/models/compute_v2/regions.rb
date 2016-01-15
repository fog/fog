module Fog
  module Compute
    class DigitalOceanV2
      class Regions < Fog::Collection
        model Fog::Compute::DigitalOceanV2::Region

        # Retrieves regions
        # @return [Fog::Compute::DigitalOceanV2:Regions]
        # @raise [Fog::Compute::DigitalOceanV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::DigitalOceanV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::DigitalOceanV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::DigitalOceanV2::ServiceError]
        # @see https://developers.digitalocean.com/documentation/v2/#list-all-regions
        def all(filters = {})
          data = service.list_regions(filters).body["regions"]
          load(data)
        end
      end
    end
  end
end