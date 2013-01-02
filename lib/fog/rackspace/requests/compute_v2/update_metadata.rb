module Fog
  module Compute
    class RackspaceV2
      class Real
        def update_metadata(collection, server_id, metadata = {})
          request(
            :expects => [200, 203],
            :method => 'POST',
            :path => "/#{collection}/#{server_id}/metadata",
            :body => Fog::JSON.encode('metadata' => metadata)            
          )
        end
      end
      
      class Mock
        def update_metadata(collection, server_id, metadata = {})
          raise Fog::Compute::RackspaceV2::NotFound if server_id == 0
          
          response = Excon::Response.new
          response.status = 202
          response.body = {"metadata" => {"environment" => "dev", "Tag" => "Database"}}
          response            
        end
      end
    end
  end
end
