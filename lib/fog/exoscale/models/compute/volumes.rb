require 'fog/core/collection'
require 'fog/exoscale/models/compute/volume'

module Fog
  module Compute
    class Exoscale
      class Volumes < Fog::Collection
        model Fog::Compute::Exoscale::Volume

        def all
          raise Fog::Errors::Error.new('Listing volumes is not supported')
        end

        def get(volume_id)
          raise Fog::Errors::Error.new('Listing volume is not supported')
        end
      end
    end
  end
end
