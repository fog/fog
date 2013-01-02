module Fog
  module Compute
    class RackspaceV2
      class Real
        def list_server_metadata(server_id)
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => "/servers/#{server_id}/metadata"
          )
        end
      end
      
      class Mock
        def list_server_metadata(server_id)
          raise Fog::Compute::RackspaceV2::NotFound if server_id == 0

          response = Excon::Response.new
          response.status = 202
          response.body = { "metadata"=>{"Tag"=>"Database"} }
          response
        end
      end
    end
  end
end
