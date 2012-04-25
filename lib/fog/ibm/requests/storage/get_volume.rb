module Fog
  module Storage
    class IBM
      class Real

        # Used to retrieve the specified storage volume for specified volume_id
        #
        # ==== Parameters
        # * volume_id<~String> - Id of storage volume
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def get_volume(volume_id)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/storage/#{volume_id}"
          )
        end

      end

      class Mock

        # For whatever reason, get_volume returns different data than an entry in list_volumes
        def get_volume(volume_id)
          response = Excon::Response.new
          if volume_exists? volume_id
            response.status = 200
            response.body   = format_get_volume_response_for(volume_id)
          else
            response.status = 404
          end
          response
        end

        # get_volume response doesn't contain instanceId
        def format_get_volume_response_for(volume_id)
          # If we aren't attached/ready, make us ready
          ready_volume(volume_id) unless volume_attached? volume_id
          self.data[:volumes][volume_id].reject { |k,v| k == 'instanceId' }
        end

        # The list_volumes response doesn't contain ioPrice
        def format_list_volumes_response
          self.data[:volumes].values.dup.map { |volume| volume.reject { |k,v| k == 'ioPrice'} }
        end

        def volume_exists?(volume_id)
          self.data[:volumes].key? volume_id
        end

        # Checks if an volume is Active
        def volume_ready?(volume_id)
          self.data[:volumes][volume_id]['state'] == 4
        end

        def volume_attached?(volume_id)
          self.data[:volumes][volume_id]['instanceId'] != "0"
        end

        # Sets volume status to Detached if it's not already set, and or attached
        def ready_volume(volume_id)
          # If not ready, make ready
          self.data[:volumes][volume_id]['state'] = 4
        end

      end
    end
  end
end
