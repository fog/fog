module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Returns a list of features supported by the RAPI server.

        def cluster_features
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/2/features"
          )
        end

      end

      class Mock

        def cluster_features
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
