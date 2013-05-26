require 'fog/core/collection'
require 'fog/openstack/models/volume/snapshot'

module Fog
  module Volume
    class OpenStack
      class Snapshots < Fog::Collection
        
        attribute :filters
        
        model Fog::Volume::OpenStack::Snapshot

        def initialize(attributes)
          self.filters ||= {}
          super
        end
        
        def all(detailed = true, filters = filters)
          self.filters = filters
          load(service.list_snapshots(detailed, filters).body['snapshots'])
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