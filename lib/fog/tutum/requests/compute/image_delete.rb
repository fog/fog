module Fog
  module Compute
    class Tutum
      class Real
        def image_delete(name)
          request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "image/#{name}/"
          )
        end
      end

      class Mock
        def image_delete(name)
          ""
        end
      end
    end
  end
end
