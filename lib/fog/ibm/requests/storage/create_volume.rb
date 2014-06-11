module Fog
  module Storage
    class IBM
      class Real
        # Requests a new Storage Volume be created.
        #
        # ==== Parameters
        # * name<~String> - The alias to use to referance storage volume
        # * offeringID<~String> - offering id can be requested from /computecloud/enterprise/api/rest/20100331/offerings/storage
        # * format<~String> - filesystem format for volume
        # * location<~String> - datacenter location for volume
        # * size<~String> - size of volume desired (Small, Medium, Large) (varies by location what size actually is)
        # * storageAreaID<~String> - (not supported yet)
        #
        # === Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * name<~String> - The alias to use to referance storage volume
        #     * format<~String> - filesystem format for storage
        #     * location<~String> - datacenter location for storage
        #     * createdTime<~Integer> - Epoch time of creation
        #     * size<~String> - size of storage desired (Small, Medium, Large) (varies by location what size actually is)
        #     * productCodes<~Array> -
        #     * offeringID<~String> - offering id can be requested from /computecloud/enterprise/api/rest/20100331/offerings/storage
        #     * id<~String> - id of new storage
        #     * owner<~String> - owner of new storage
        #     * state<~Integer> - state of newly requested storage
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
          volume          = Fog::IBM::Mock.create_volume(name, offering_id, format, location_id, size)
          self.data[:volumes][volume['id']] = volume
          response        = Excon::Response.new
          response.status = 200
          response.body   = format_create_volume_response_for(volume['id'])
          response
        end

        # The create_volume response doesn't contain ioPrice either
        def format_create_volume_response_for(volume_id)
          # If we aren't attached/ready, make us ready
          ready_volume(volume_id) unless volume_attached? volume_id
          self.data[:volumes][volume_id].reject { |k,v| k == 'ioPrice' }
        end
      end
    end
  end
end
