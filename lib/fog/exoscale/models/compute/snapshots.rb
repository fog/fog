require 'fog/core/collection'
require 'fog/exoscale/models/compute/snapshot'

module Fog
  module Compute
    class Exoscale
      class Snapshots < Fog::Collection
        model Fog::Compute::Exoscale::Snapshot

        def all
          raise Fog::Errors::Error.new('Listing snapshots is not supported')
        end

        def get(snapshot_id)
          raise Fog::Errors::Error.new('Retrieving a snapshot is not supported')
        end
      end
    end
  end
end
