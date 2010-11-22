module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Change the node role.
        #
        # It supports the bool force argument.

        def node_role_create node_name
          request(
            :expects => 200,
            :method  => 'PUT',
            :query   => opts.delete(:query),
            :path    => "/2/nodes/#{node_name}/role"
          )
        end

      end

      class Mock

        def node_role_create node_name
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
