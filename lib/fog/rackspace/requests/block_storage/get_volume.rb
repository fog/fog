module Fog
  module Rackspace
    class BlockStorage
      class Real
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
