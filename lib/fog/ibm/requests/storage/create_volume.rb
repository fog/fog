module Fog
  module Storage
    class IBM
      class Real

        # Create a volume
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def create_volume(name, offering_id, format, location_id, size)
          request(
            :method   => 'POST',
            :expects  => 200,
            :path     => '/storage',
            :body     => {
              'name'       => name,
              'offeringID' => offering_id,
              'format'     => format,
              'location'   => location_id,
              'size'       => size
            }
          )
        end

      end
    end
  end
end
