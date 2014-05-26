module Fog
  module Compute
    class CloudSigma
      class Real
        def start_server(server_id, start_params={})
          request(:path => "servers/#{server_id}/action/",
                  :method => 'POST',
                  :query => {:do => :start}.merge!(start_params),
                  :expects => [200, 202])
        end
      end

      class Mock
        def start_server(server_id, start_params={})
          server = self.data[:servers][server_id]
          server['status'] = 'running'

          response = Excon::Response.new
          response.status = 200
          response.body = {
              'action' => 'start',
              'result' => 'success',
              'uuid' => server_id
          }

          response
        end
      end
    end
  end
end
