module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Replaces disks on an instance.
        # Returns a job id.
        #
        # Takes the mandatory  parameters mode:
        #  - (one of replace_on_primary, replace_on_secondary, replace_new_secondary or replace_auto),
        #  - disks (comma separated list of disk indexes)
        #  - remote_node and iallocator
        #
        # Either remote_node or iallocator needs to be defined when using mode=replace_new_secondary.
        # replace_auto tries to determine the broken disk(s) on its own and replacing it.

        def instance_replace_disks instance_name, opts = {}
          request(
            :expects => 200,
            :method  => 'POST',
            :query   => opts.delete(:query),
            :path    => "/2/instances/#{instance_name}/replace-disks"
          )
        end

      end

      class Mock

        def instance_replace_disks instance_name, opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
