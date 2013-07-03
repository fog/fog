module Fog
  module Rackspace
    class Monitoring
      class Real

        def get_entity(entity_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "entities/#{entity_id}"
          )
        end

      end
    end
  end
end


