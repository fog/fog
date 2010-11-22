module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Migrates all primary instances from a node.
        #
        # If no mode is explicitly specified, each instances’ hypervisor
        # default migration mode will be used. Query parameters:
        #   - live (bool): If set, use live migration if available.
        #   - mode (string): Sets migration mode, live for live migration
        #     and non-live for non-live migration. Supported by Ganeti 2.2 and above.

        def node_migrate node_name
          request(
            :expects => 200,
            :method  => 'POST',
            :query   => opts.delete(:query),
            :path    => "/2/nodes/#{node_name}/migrate"
          )
        end

      end

      class Mock

        def nodes_migrate node_name
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
