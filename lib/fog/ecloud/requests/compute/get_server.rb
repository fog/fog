module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_server
      end

      class Mock
        def get_server(uri)
          server_id = uri.match(/(\d+)/)
          server_id = server_id.nil? ? nil : server_id[1].to_i
          server = self.data[:servers][server_id]
          if server
            response(:body => Fog::Ecloud.slice(server, :id, :compute_pool_id))
          else raise Fog::Errors::NotFound
          end
        end
      end
    end
  end
end
