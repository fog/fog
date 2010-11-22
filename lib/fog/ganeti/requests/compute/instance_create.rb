module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Creates an instance.
        # Returns a job id.
        #
        # Body parameters:
        #   - http://docs.ganeti.org/ganeti/2.2/html/rapi.html#instances
        #
        # If the optional dry-run parameter (?dry-run=1) is provided,
        # the job will not be actually executed, only the pre-execution
        # checks will be done.

        def instance_create opts = {}
          request(
            :expects => 200,
            :method  => 'POST',
            :query   => opts.delete(:query),
            :path    => "/2/instances",
            :body    => opts.to_json
          )
        end

      end

      class Mock

        def instance_create opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
