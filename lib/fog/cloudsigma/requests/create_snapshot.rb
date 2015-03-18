module Fog
  module Compute
    class CloudSigma
      class Real
        def create_snapshot(data)
          create_request("snapshots/", data)
        end
      end

      class Mock
        def create_snapshot(data)
          uuid = self.class.random_uuid

          defaults = {'uuid' => uuid,
                      'timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N%z"),
                      'status' => 'creating',
                      'tags' => [],
                      'grantees' => [],
                      'allocated_size' => 0
          }

          mock_create(:snapshots, 201, data, uuid, defaults)
        end
      end
    end
  end
end
