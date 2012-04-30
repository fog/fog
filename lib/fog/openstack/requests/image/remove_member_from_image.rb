module Fog
  module Image
    class OpenStack
      class Real
        def remove_member_from_image(image_id, member_id)
          request(
            :expects => [200, 204],
            :method  => 'DELETE',
            :path    => "images/#{image_id}/members/#{member_id}"
          )
        end
      end # class Real

      class Mock
        def remove_member_from_image(image_id, member_id)
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          response
        end # def list_tenants
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
