require 'fog/core/collection'
require 'fog/openstack/models/compute/snapshot'

module Fog
  module Compute
    class OpenStack
      class Snapshots < Fog::Collection
        model Fog::Compute::OpenStack::Snapshot

        def all(options = {})
          if !options.is_a?(Hash)
            if options
              Fog::Logger.deprecation('Calling OpenStack[:compute].snapshots.all(true) is deprecated, use .snapshots.all')
            else
              Fog::Logger.deprecation('Calling OpenStack[:compute].snapshots.all(false) is deprecated, use .snapshots.summary')
            end
            load(service.list_snapshots(options).body['snapshots'])
          else
            load(service.list_snapshots_detail(options).body['snapshots'])
          end
        end

        def summary(options = {})
          load(service.list_snapshots(options).body['snapshots'])
        end

        def get(snapshot_id)
          if snapshot = service.get_snapshot_details(snapshot_id).body['snapshot']
            new(snapshot)
          end
        rescue Fog::Compute::OpenStack::NotFound
          nil
        end
      end
    end
  end
end
