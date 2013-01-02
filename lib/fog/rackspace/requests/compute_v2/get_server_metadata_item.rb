module Fog
  module Compute
    class RackspaceV2
      class Real
        def get_server_metadata_item(server_id, key)
          request(
            :expects => 200,
            :method => 'GET',
            :path => "/servers/#{server_id}/metadata/#{key}"
          )
        end
      end
      
      class Mock
        def get_server_metadata_item(server_id, key)
          raise Fog::Compute::RackspaceV2::NotFound if server_id == 0
          
          response = Excon::Response.new
          response.status = 202
          response.body = {"meta" => {"environment" => "dev"}}
          response            
        end
      end
    end
  end
end
