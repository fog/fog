module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Activate disks on an instance.
        # Returns a job id.
        #
        # Takes the bool parameter ignore_size.
        # (useful for forcing activation when recorded size is wrong).

        def instance_activate_disks instance_name, opts = {}
          request(
            :expects => 200,
            :method  => 'PUT',
            :query   => opts.delete(:query),
            :path    => "/2/instances/#{instance_name}/activate-disks"
          )
        end

      end

      class Mock

        def instance_activate_disks instance_name, opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
