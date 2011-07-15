module Fog
  module DNS
    class Dynect
      class Real

        # Get one or more node lists
        #
        # ==== Parameters
        # * zone<~String> - zone to lookup node lists for
        # * options<~Hash>
        #   * fqdn<~String> - fully qualified domain name of node to lookup

        def get_node_list(zone, options = {})
          request(
            :expects  => 200,
            :method   => :get,
            :path     => ['NodeList', zone, options['fqdn']].compact.join('/')
          )
        end
      end
    end
  end
end
