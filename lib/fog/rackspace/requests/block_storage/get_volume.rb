module Fog
  module Rackspace
    class BlockStorage
      class Real

        # Retrieves volume detail
        # @param [String] volume_id
        # @return [Excon::Response] response
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/GET_getVolume__v1__tenant_id__volumes.html
        def get_volume(volume_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "volumes/#{volume_id}"
          )
        end
      end

      class Mock
        def get_volume(volume_id)
          possible_states = ["available", "in-use"]
          volume = self.data[:volumes][volume_id]
          if volume.nil?
            raise Fog::Rackspace::BlockStorage::NotFound
          else
            volume["status"] = possible_states[rand(possible_states.length)]
            if volume.nil?
              raise Fog::Rackspace::BlockStorage::NotFound
            else
              response(:body => {"volume" => volume})
            end
          end
        end
      end
    end
  end
end
