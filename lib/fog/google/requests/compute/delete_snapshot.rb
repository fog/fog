module Fog
  module Compute
    class Google

      class Mock

        def delete_snapshot(snapshot_name, zone_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def delete_snapshot(snapshot_name, zone_name_or_url)
          zone_name = get_zone_name(zone_name_or_url)
          api_method = @compute.snapshots.delete
          parameters = {
            'project' => @project,
            'snapshot' => snapshot_name,
            'zone' => zone_name,
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
