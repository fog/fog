module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Deactivate disks on an instance.
        # Returns a job id.

        def instance_deactivate_disks instance_name
          request(
            :expects => 200,
            :method  => 'PUT',
            :path    => "/2/instances/#{instance_name}/deactivate-disks"
          )
        end

      end

      class Mock

        def instance_deactivate_disks instance_name
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
