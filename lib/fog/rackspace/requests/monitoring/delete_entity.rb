module Fog
  module Rackspace
    class Monitoring
      class Real

        def delete_entity(entity_id)
          request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "entities/#{entity_id}"
          )
        end
      end
    end
  end
end

