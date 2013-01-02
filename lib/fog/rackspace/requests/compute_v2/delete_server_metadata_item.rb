module Fog
  module Compute
    class RackspaceV2
      class Real
        def delete_server_metadata_item(server_id, key)
          request(
            :expects => 204,
            :method => 'DELETE',
            :path => "/servers/#{server_id}/metadata/#{key}"
          )
        end
      end
      
      class Mock
        def delete_server_metadata_item(server_id, key)
          raise Fog::Compute::RackspaceV2::NotFound if server_id == 0
          
          response = Excon::Response.new
          response.body = ""                      
          response.status = 204
          response            
        end
      end
    end
  end
end
