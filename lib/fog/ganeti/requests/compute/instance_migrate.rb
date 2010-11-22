module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Migrates an instance.
        # Returns a job id.
        #
        # Body parameters:
        #   - http://docs.ganeti.org/ganeti/2.2/html/rapi.html#instances-instance-name-migrate

        def instance_migrate instance_name, opts = {}
          request(
            :expects => 200,
            :method  => 'PUT',
            :path    => "/2/instances/#{instance_name}/migrate",
            :body    => opts.to_json
          )
        end

      end

      class Mock

        def instance_migrate instance_name, opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
