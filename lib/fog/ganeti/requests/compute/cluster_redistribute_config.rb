module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Redistribute configuration to all nodes.
        # Returns a job id.

        def cluster_redistribute_config
          request(
            :expects => 200,
            :method  => 'PUT',
            :path    => '/2/redistribute-config'
          )
        end

      end

      class Mock

        def cluster_redistribute_config
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
