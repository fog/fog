module Fog
  module Compute
    class RackspaceV2
      class Real
        def delete_metadata_item(collection, obj_id, key)
          request(
            :expects => 204,
            :method => 'DELETE',
            :path => "/#{collection}/#{obj_id}/metadata/#{key}"
          )
        end
      end
      
      class Mock
        def delete_metadata_item(collection, obj_id, key)
          raise Fog::Compute::RackspaceV2::NotFound if obj_id == 0
          
          response = Excon::Response.new
          response.body = ""                      
          response.status = 204
          response            
        end
      end
    end
  end
end
