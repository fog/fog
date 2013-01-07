module Fog
  module Compute
    class RackspaceV2
      class Real
        def list_metadata(collection, obj_id)
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => "/#{collection}/#{obj_id}/metadata"
          )
        end
      end
      
      class Mock
        def list_metadata(collection, obj_id)
          raise Fog::Compute::RackspaceV2::NotFound if obj_id == 0

          response = Excon::Response.new
          response.status = 202
          response.body = { "metadata"=>{"tag"=>"database"} }
          response
        end
      end
    end
  end
end
