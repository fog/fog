module Fog
  module Image
    class OpenStack
      class Real
        def list_public_images_detailed(attribute=nil, query=nil)
          path = 'images/detail'
          if attribute
            query = { attribute => URI::encode(query) }
          else
            query = {}
          end

          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => path,
            :query   => query
          )
        end
      end # class Real

      class Mock
        def list_public_images_detailed(attribute=nil, query=nil)
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          response.body = {'images' => self.data[:images].values}
          response
        end # def list_public_images_detailed
      end # class Mock
    end # class OpenStack
  end # module Image
end # module Fog
