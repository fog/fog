module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Returns a list of cluster information.

        def cluster_info
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/2/info"
          )
        end

      end

      class Mock

        def cluster_info
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
