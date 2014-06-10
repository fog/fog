module Fog
  module Compute
    class CloudSigma
      class Real
        def create_server(data)
          create_request("servers/", data)
        end
      end

      class Mock
        def create_server(data)
          uuid = self.class.random_uuid

          defaults = {'uuid' => uuid,
                      'status' => 'stopped',
                      'smp' => 1,
                      'hv_relaxed' => false,
                      'hv_tsc' => false,
                      'enable_numa' => false,
                      'cpus_instead_of_cores' => false,
                      'drives' => [],
                      'nics' => [],
                      'tags' => []
          }

          mock_create(:servers, 202, data, uuid, defaults)
        end
      end
    end
  end
end
