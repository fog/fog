module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Deletes tags.
        # Returns a job id.
        #
        # If the optional dry-run parameter (?dry-run=1) is provided,
        # the job will not be actually executed, only the pre-execution
        # checks will be done.

        def node_tags_delete node_name, opts = {}
          request(
            :expects => 200,
            :method  => 'DELETE',
            :query   => opts.delete(:query),
            :path    => "/2/nodes/#{node_name}/tags"
          )
        end

      end

      class Mock

        def node_tags_delete node_name, opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
