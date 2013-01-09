module Fog
  module Compute
    class RackspaceV2
      class Real
        def get_metadata_item(collection, obj_id, key)
          request(
            :expects => 200,
            :method => 'GET',
            :path => "/#{collection}/#{obj_id}/metadata/#{key}"
          )
        end
      end
      
      class Mock
        def get_metadata_item(collection, obj_id, key)
          raise Fog::Compute::RackspaceV2::NotFound if obj_id == 0
          
          response = Excon::Response.new
          response.status = 202
          response.body = {"meta" => {"environment" => "dev"}}
          response            
        end
      end
    end
  end
end
