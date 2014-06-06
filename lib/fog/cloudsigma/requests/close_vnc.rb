module Fog
  module Compute
    class CloudSigma
      class Real
        def close_vnc(server_id)
          request(:path => "servers/#{server_id}/action/",
                  :method => 'POST',
                  :query => {:do => :close_vnc},
                  :expects => [200, 202])
        end
      end

      class Mock
        def close_vnc(server_id)
          response = Excon::Response.new
          response.status = 200

          response.body = {
              'action' => 'close_vnc',
              'result' => 'success',
              'uuid' => server_id,
          }

          response
        end
      end
    end
  end
end
