module Fog
  module Compute
    class CloudSigma
      class Real
        def open_vnc(server_id)
          request(:path => "servers/#{server_id}/action/",
                  :method => 'POST',
                  :query => {:do => :open_vnc},
                  :expects => [200, 202])
        end
      end

      class Mock
        def open_vnc(server_id)
          response = Excon::Response.new
          response.status = 200
          host = @init_options[:cloudsigma_host]
          port = Fog::Mock.random_number(65000)
          vnc_url = "vnc://#{host}:#{port}"

          response.body = {
              'action' => 'open_vnc',
              'result' => 'success',
              'uuid' => server_id,
              'vnc_url' => vnc_url
          }

          response
        end
      end
    end
  end
end
