require 'fog/core/collection'
require 'fog/cloudsigma/models/volume'

module Fog
  module Compute
    class CloudSigma
      class Volumes < Fog::Collection
        model Fog::Compute::CloudSigma::Volume

        def all
          resp = service.list_volumes
          data = resp.body['objects']
          load(data)
        end

        def get(vol_id)
          resp = service.get_volume(vol_id)
          data = resp.body
          new(data)
        rescue Fog::CloudSigma::Errors::NotFound
          return nil
        end
      end
    end
  end
end
