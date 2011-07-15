module Fog
  module DNS
    class Dynect
      class Real

        # Update a zone
        #
        # ==== Parameters
        # * zone<~String> - name or id of zone
        # * options<~Hash>:
        #   * freeze<~Boolean> - causes zone to become frozen
        #   * publish<~Boolean> - causes all pending changes to be pushed to nameservers
        #   * thaw<~Boolean> - causes zone to cease being frozen

        def put_zone(zone, options = {})
          request(
            :body     => MultiJson.encode(options),
            :expects  => 200,
            :method   => :put,
            :path     => 'Zone/' << zone
          )
        end
      end
    end
  end
end
