module Fog
  module Rackspace
    class Monitoring
      class Real

        def get_check(entity_id, check_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "entities/#{entity_id}/checks/#{check_id}"
          )
        end

      end
    end
  end
end


