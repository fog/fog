module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Reinstalls the instance's operating system.
        # Returns a job id.
        #
        # Takes the parameters os (OS template name) and nostartup (bool).

        def instance_reinstall instance_name, opts = {}
          request(
            :expects => 200,
            :method  => 'POST',
            :query   => opts.delete(:query),
            :path    => "/2/instances/#{instance_name}/reinstall"
          )
        end

      end

      class Mock

        def instance_reinstall instance_name, opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
