module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Requests detailed information about the instance.
        #
        # An optional parameter, static (bool), can be set to return only static
        # information from the configuration without querying the instance’s nodes.
        # The result will be a job id.

        def instance_info instance_name, opts = {}
          request(
            :expects => 200,
            :method  => 'GET',
            :query   => opts.delete(:query),
            :path    => "/2/instances/#{instance_name}/info"
          )
        end

      end

      class Mock

        def instance_info instance_name, opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
