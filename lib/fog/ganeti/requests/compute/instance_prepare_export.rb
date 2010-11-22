module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Prepares an export of an instance.
        # Returns a job id.
        #
        # Takes one parameter, mode, for the export mode.

        def instance_prepare_export instance_name, opts = {}
          request(
            :expects => 200,
            :method  => 'PUT',
            :query   => opts.delete(:query),
            :path    => "/2/instances/#{instance_name}/prepare-disks"
          )
        end

      end

      class Mock

        def instance_prepare_export instance_name, opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
