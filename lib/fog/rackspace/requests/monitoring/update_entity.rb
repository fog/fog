module Fog
  module Rackspace
    class Monitoring
      class Real

        def update_entity(id, options)
          request(
            :body     => JSON.encode(options),
            :expects  => [204],
            :method   => 'PUT',
            :path     => "entities/#{id}"
          )
        end
      end
    end
  end
end

