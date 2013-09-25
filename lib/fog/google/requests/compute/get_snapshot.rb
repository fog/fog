module Fog
  module Compute
    class Google

      class Mock

        def get_snapshot(snap_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def get_snapshot(snap_name, project=@project)
          if snap_name.nil?
            raise ArgumentError.new "snap_name must not be nil."
          end

          api_method = @compute.snapshots.get
          parameters = {
            'snapshot' => snap_name,
            'project'  => project,
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
