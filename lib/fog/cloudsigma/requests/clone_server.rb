module Fog
  module Compute
    class CloudSigma
      class Real
        def clone_server(server_id, clone_params={})
          request(:path => "servers/#{server_id}/action/",
                  :method => 'POST',
                  :query => {:do => :clone},
                  :body => clone_params,
                  :expects => [200, 202])
        end
      end

      class Mock
        def clone_server(server_id, clone_params={})
          server = self.data[:servers][server_id].dup
          uuid = self.class.random_uuid
          server['uuid'] = uuid

          self.data[:servers][uuid] = server

          response = Excon::Response.new
          response.status = 200
          response.body = server

          response
        end
      end
    end
  end
end
