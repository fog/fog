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

      class Mock

        def create_volume(name, offering_id, format, location_id, size)
          volume          = Fog::IBM::Mock.create_volume(name, format, location_id, size, offering_id)
          self.data[:volumes][volume['id']] = volume
          response        = Excon::Response.new
          response.status = 200
          response.body   = format_get_volume_response_for(volume['id'])
          response
        end

      end
    end
  end
end
