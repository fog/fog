require 'fog/openstack/models/collection'
require 'fog/openstack/models/volume/snapshot'

module Fog
  module Volume
    class OpenStack
      class Snapshots < Fog::OpenStack::Collection
        model Fog::Volume::OpenStack::Snapshot

        def all(options = {})
          if !options.is_a?(Hash)
            if options
              Fog::Logger.deprecation('Calling OpenStack[:volume].snapshots.all(true) is deprecated, use .snapshots.all')
            else
              Fog::Logger.deprecation('Calling OpenStack[:volume].snapshots.all(false) is deprecated, use .snapshots.summary')
            end
            load_response(service.list_snapshots(options), 'snapshots')
          else
            load_response(service.list_snapshots_detailed(options), 'snapshots')
          end
        end

        def summary(options = {})
          load_response(service.list_snapshots(options), 'snapshots')
        end

        def get(snapshot_id)
          if snapshot = service.get_snapshot_details(snapshot_id).body['snapshot']
            new(snapshot)
          end
        rescue Fog::Volume::OpenStack::NotFound
          nil
        end
      end
    end
  end
end
