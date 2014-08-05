require 'fog/core/collection'
require 'fog/cloudsigma/models/lib_volume'

module Fog
  module Compute
    class CloudSigma
      class LibVolumes < Fog::Collection
        model Fog::Compute::CloudSigma::LibVolume

        def all
          resp = service.list_lib_volumes
          data = resp.body['objects']
          load(data)
        end

        def get(vol_id)
          resp = service.get_lib_volume(vol_id)
          data = resp.body
          new(data)
        rescue Fog::CloudSigma::Errors::NotFound
          return nil
        end
      end
    end
  end
end
