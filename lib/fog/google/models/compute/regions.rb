require 'fog/core/collection'
require 'fog/google/models/compute/region'

module Fog
  module Compute
    class Google
      class Regions < Fog::Collection
        model Fog::Compute::Google::Region

        def all
          data = service.list_regions.body
          load(data['items'] || [])
        end

        def get(identity)
          if region = service.get_region(identity).body
            new(region)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
