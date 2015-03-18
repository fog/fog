module Fog
  module Compute
    class CloudSigma
      class Real
        def stop_server(server_id, do_graceful_acpi = false)
          action = do_graceful_acpi ? :shutdown : :stop
          request(:path => "servers/#{server_id}/action/",
                  :method => 'POST',
                  :query => {:do => action},
                  :expects => [200, 202])
        end
      end

      class Mock
        def stop_server(server_id)
          server = self.data[:servers][server_id]
          server['status'] = 'stopped'

          response = Excon::Response.new
          response.status = 200
          response.body = {
              'action' => 'stop',
              'result' => 'success',
              'uuid' => server_id
          }

          response
        end
      end
    end
  end
end
