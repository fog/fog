module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Startup an instance.
        # Returns a job id.
        #
        # If the optional dry-run parameter (?dry-run=1) is provided,
        # the job will not be actually executed, only the pre-execution
        # checks will be done.

        def instance_startup instance_name, opts = {}
          request(
            :expects => 200,
            :method  => 'PUT',
            :query   => opts.delete(:query),
            :path    => "/2/instances/#{instance_name}/startup"
          )
        end

      end

      class Mock

        def instance_startup instance_name, opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
