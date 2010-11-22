module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Returns a list of all nodes.
        #
        # If the optional bulk parameter (?bulk=1) is provided,
        # the output contains detailed information about instances as a list.

        def nodes_list opts = {}
          request(
            :expects => 200,
            :method  => 'GET',
            :query   => opts.delete(:query),
            :path    => "/2/nodes"
          )
        end

      end

      class Mock

        def nodes_list opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
