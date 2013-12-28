module Fog
  module Compute
    class Google

      class Mock

        def insert_snapshot(snap_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def insert_snapshot(disk_name, zone_name, opts={})

          # This is unfortunate, since we might be called from 2 contexts
          # 1. disk.snapshot <-- here validation of disk_name is not needed
          # 2. snapshot.create <-- here we must validate the disk_name
          #
          # Validation would involve 'get'ing the disk by that name. This is
          # redundant (and expensive) for case (1) which is likely the common
          # codepath. So we won't do it.

          api_method = @compute.disks.create_snapshot

          parameters = {
            'disk'    => disk_name,
            'zone'    => zone_name,
            'project' => @project,
          }

          snap_name = opts.delete('name')
          puts "snap_name = #{snap_name}"
          raise ArgumentError.new('Must specify snapshot name') unless snap_name
          raise ArgumentError.new('Snapshot name should be 63 letters long.') if snap_name.size > 63
          body_object = { 'name' => snap_name }

          # Merge in any remaining options (description)
          body_object.merge(opts)

          result = self.build_result(api_method, parameters,
                                     body_object)
          response = self.build_response(result)
        end

      end

    end
  end
end
