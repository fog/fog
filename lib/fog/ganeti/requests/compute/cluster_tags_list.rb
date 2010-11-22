module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Returns the cluster tags.

        def cluster_tags_list
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/2/tags"
          )
        end

      end

      class Mock

        def cluster_tags_list
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
