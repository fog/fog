module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Returns information about a node.

        def node_list node_name
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/2/nodes/#{node_name}"
          )
        end

      end

      class Mock

        def nodes_list node_name
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
