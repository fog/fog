module Fog
  module Compute
    class IBM
      class Real
        # Get a location
        #
        # ==== Parameters
        # * location_id<~String> - Id of location
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'name'<~String>: location name
        #     * 'location'<~String>:
        #     * 'capabilities'<~Array>:
        #       * 'oss.storage.format'<~Hash>:
        #         * 'entries'<~Array>: list of supported volume formats
        #         * 'oss.instance.spec.i386'<~Array>: unsure.. returns empty array
        #         * 'oss.instance.spec.x86_64'<~Array>: unsure.. returns empty array
        #         * 'oss.storage.availabilityarea'<~Array>: availability area unsupported
        #     * 'id'<~String>: id of location
        #     * 'description'<~String>: description including geographic location
        #     * 'state'<~String>: state of datacenter
        def get_location(location_id)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/locations/#{location_id}"
          )
        end
      end

      class Mock
        def get_location(location_id)
          response = Excon::Response.new
          if location_exists? location_id
            response.status = 200
            response.body   = self.data[:locations][location_id]
          else
            response.status = 404
          end
          response
        end

        def location_exists?(location_id)
          self.data[:locations].key? location_id
        end
      end
    end
  end
end
