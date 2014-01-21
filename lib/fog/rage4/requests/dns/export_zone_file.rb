module Fog
  module DNS
    class Rage4
      class Real

        # Delete a specific omain
        # ==== Parameters
        # * id<~Integer> - numeric ID
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #      * 'status'<~Boolean>
        #      * 'id'<~Integer>
        #      * 'error'<~String>
        def export_zone_file(id)
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => "/rapi/exportzonefile/#{id}" )

        end

      end

    end
  end
end
