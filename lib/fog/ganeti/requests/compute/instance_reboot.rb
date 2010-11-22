module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Reboots the instance.
        # Returns a job id.
        #
        # The URI takes optional type=soft|hard|full and ignore_secondaries=0|1 parameters.
        #   - soft is just a normal reboot, without terminating the hypervisor.
        #   - hard means full shutdown (including terminating the hypervisor process)
        #     and startup again.
        #   - full is like hard but also recreates the configuration from ground up
        #     as if you would have done a gnt-instance shutdown and gnt-instance start on it.
        #   - ignore_secondaries parameter (?ignore_secondaries=1), will start the
        #     instance even if secondary disks are failing.
        #
        # If the optional dry-run parameter (?dry-run=1) is provided,
        # the job will not be actually executed, only the pre-execution
        # checks will be done.

        def instance_reboot instance_name, opts = {}
          request(
            :expects => 200,
            :method  => 'POST',
            :query   => opts.delete(:query),
            :path    => "/2/instances/#{instance_name}/reboot"
          )
        end

      end

      class Mock

        def instance_reboot instance_name, opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
