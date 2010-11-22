module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Returns the cluster API version.

        def cluster_version
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/2/version"
          )
        end

      end

      class Mock

        def cluster_version
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
