module Fog
  module Compute
    class Google

      class Mock

        def insert_snapshot(snap_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def insert_snapshot(disk_name, zone_name_or_url, project=@project, options={})

          # This is unfortunate, since we might be called from 2 contexts
          # 1. disk.snapshot <-- here validation of disk_name is not needed
          # 2. snapshot.create <-- here we must validate the disk_name
          #
          # Validation would involve 'get'ing the disk by that name. This is
          # redundant (and expensive) for case (1) which is likely the common
          # codepath. So we won't do it.

          api_method = @compute.disks.create_snapshot

          parameters = disk_request_parameters(disk_name, zone_name_or_url)

          snapshot_name = options.delete('name')
          raise ArgumentError.new('Must specify snapshot name') unless snapshot_name
          body_object = { 'name' => snapshot_name }

          # Merge in any remaining options (description)
          body_object.merge(options)

          result = self.build_result(api_method, parameters,
                                     body_object)
          response = self.build_response(result)
        end

      end

    end
  end
end
