module Fog
  module Rackspace
    class Monitoring
      class Real

        def delete_check(entity_id, check_id)
          request(
            :expects  => [204],
            :method   => 'DELETE',
            :path     => "entities/#{entity_id}/checks/#{check_id}"
          )
        end
      end
    end
  end
end

