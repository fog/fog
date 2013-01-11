module Fog
  module Compute
    class RackspaceV2
      class Real
        def set_metadata_item(collection, obj_id, key, value)
          request(
            :expects => 200,
            :method => 'PUT',
            :path => "/#{collection}/#{obj_id}/metadata/#{key}",
            :body => Fog::JSON.encode('meta' => { key => value })        
          )
        end
      end
      
      class Mock
        def set_metadata_item(collection, obj_id, key, value)
          raise Fog::Compute::RackspaceV2::NotFound if obj_id == 0
          
          response = Excon::Response.new
          response.status = 202
          response.body = {"meta" => {key => value}}
          response            
        end
      end
    end
  end
end
