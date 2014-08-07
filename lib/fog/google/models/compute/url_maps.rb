require 'fog/core/collection'
require 'fog/google/models/compute/url_map'

module Fog
  module Compute
    class Google
      class UrlMaps < Fog::Collection
        model Fog::Compute::Google::UrlMap

        def all
          data = service.list_url_maps.body['items'] || []
          load(data)
        end

        def get(identity)
          response = service.get_url_map(identity)
          new(response.body) unless response.nil?
        end
      end
    end
  end
end
