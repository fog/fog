module Fog
  module DNS
    class Rage4
      class Real

        # List all the record types available
        # ==== Parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'domains'<~Hash>

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
