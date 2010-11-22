module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Delete tags.
        # Returns a job id.
        #
        # If the optional dry-run parameter (?dry-run=1) is provided,
        # the job will not be actually executed, only the pre-execution
        # checks will be done.

        def cluster_tags_delete opts = {}
          request(
            :expects => 200,
            :method  => 'DELETE',
            :query   => opts.delete(:query),
            :path    => "/2/tags"
          )
        end

      end

      class Mock

        def cluster_tags_delete opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
