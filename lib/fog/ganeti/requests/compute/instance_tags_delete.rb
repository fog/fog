module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Delete a tag.
        # Returns a job id.
        #
        # If the optional dry-run parameter (?dry-run=1) is provided,
        # the job will not be actually executed, only the pre-execution
        # checks will be done.

        def instance_tag_delete instance_name, opts = {}
          request(
            :expects => 200,
            :method  => 'DELETE',
            :query   => opts.delete(:query),
            :path    => "/2/instances/#{instance_name}/tags"
          )
        end

      end

      class Mock

        def instance_tag_delete instance_name, opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
