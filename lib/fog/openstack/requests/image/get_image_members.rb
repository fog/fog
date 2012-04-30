module Fog
  module Image
    class OpenStack
      class Real
        def get_image_members(image_id)
          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => "images/#{image_id}/members"
          )
        end
      end # class Real

      class Mock
        def get_image_members(image_id)
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          response.body = {
              "members"=>[
                  {"member_id"=>"ff528b20431645ebb5fa4b0a71ca002f",
                   "can_share"=>false}
                         ]
              }
          response
        end # def list_tenants
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
