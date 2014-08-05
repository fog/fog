require 'fog/joyent/models/compute/snapshot'

module Fog
  module Compute
    class Joyent
      class Snapshots < Fog::Collection
        model Fog::Compute::Joyent::Snapshot

        def create(machine_id, snapshot_name)
          data = self.service.create_machine_snapshot(machine_id, snapshot_name).body
          data['machine_id'] = machine_id
          new(data)
        end

        def all(machine_id)
          data = service.list_machine_snapshots(machine_id).body.map do |m|
            m["machine_id"] = machine_id
            m
          end
          load(data)
        end

        def get(machine_id, snapshot_name)
          data = service.get_machine_snapshot(machine_id, snapshot_name).body
          if data
            data["machine_id"] = machine_id
            new(data)
          else
            nil
          end
        end
      end
    end
  end
end
