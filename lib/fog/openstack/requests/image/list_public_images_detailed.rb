module Fog
  module Image
    class OpenStack
      class Real
        def list_public_images_detailed(attribute=nil, query=nil)
          if attribute
            path = "images/detail?#{attribute}=#{URI::encode(query)}"
          else
            path = 'images/detail'
          end

          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => path
          )
        end
      end # class Real

      class Mock
        def list_public_images_detailed(attribute=nil, query=nil)
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          response.body = {'images' => self.data[:images].values}
          response
        end # def list_tenants
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
