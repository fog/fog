module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Returns the current node role.

        def node_role_list node_name
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/2/nodes/#{node_name}/role"
          )
        end

      end

      class Mock

        def node_role_list node_name
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
