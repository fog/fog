module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Exports an instance.
        # Returns a job id.
        #
        # Body parameters:
        #   - http://docs.ganeti.org/ganeti/2.2/html/rapi.html#instances-instance-name-export

        def instance_export instance_name, opts = {}
          request(
            :expects => 200,
            :method  => 'PUT',
            :path    => "/2/instances/#{instance_name}/export",
            :body    => opts.to_json
          )
        end

      end

      class Mock

        def instance_export instance_name, opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
