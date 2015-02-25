require 'fog/core/collection'
require 'fog/rackspace/models/cdn_v2/flavor'

module Fog
  module Rackspace
    class CDNV2 < Fog::Service
      class Flavors < Fog::Collection
        model Fog::Rackspace::CDNV2::Flavor

        def all
          data = service.list_flavors.body['flavors']
          load(data)
        end

        def get(name)
          data = service.get_flavor(name).body
          new(data)
        rescue Fog::Rackspace::CDNV2::NotFound
          nil
        end
      end
    end
  end
end
