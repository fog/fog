module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Repairs a storage unit on the node.
        # Returns a job id.
        #
        # Requires the parameters storage_type (currently only lvm-vg can be repaired) and
        # name (name of the storage unit).

        def node_storage_repair node_name, opts = {}
          request(
            :expects => 200,
            :method  => 'PUT',
            :query   => opts.delete(:query),
            :path    => "/2/nodes/#{node_name}/repair"
          )
        end

      end

      class Mock

        def node_storage_repair node_name, opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
