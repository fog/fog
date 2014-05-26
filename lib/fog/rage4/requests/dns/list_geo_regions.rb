module Fog
  module DNS
    class Rage4
      class Real
        # List all the geo regions available
        # ==== Parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'record types'<~Hash>
        #       *'name' <~String> geo record  name
        #       *'value' <~Integer> Integer value of the type

        def list_geo_regions
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => '/rapi/listgeoregions'
                  )
        end
      end
    end
  end
end
