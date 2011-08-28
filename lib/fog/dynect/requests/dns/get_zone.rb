module Fog
  module DNS
    class Dynect
      class Real

        # Get one or more zones
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * zone<~String> - name of zone to lookup, or omit to return list of zones

        def get_zone(options = {})
          request(
            :expects  => 200,
            :method   => :get,
            :path     => ['Zone', options['zone']].compact.join('/')
          )
        end
      end
    end
  end
end
