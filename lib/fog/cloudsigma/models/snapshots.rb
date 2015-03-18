require 'fog/core/collection'
require 'fog/cloudsigma/models/snapshot'

module Fog
  module Compute
    class CloudSigma
      class Snapshots < Fog::Collection
        model Fog::Compute::CloudSigma::Snapshot

        def all
          resp = service.list_snapshots
          data = resp.body['objects']
          load(data)
        end

        def get(snap_id)
          resp = service.get_snapshot(snap_id)
          data = resp.body
          new(data)
        rescue Fog::CloudSigma::Errors::NotFound
          return nil
        end
      end
    end
  end
end
