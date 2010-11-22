module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Modifies storage units on the node.
        # Returns a job id.
        #
        # Requires the parameters storage_type (one of file, lvm-pv or lvm-vg) and name (name of the storage unit).
        # Parameters can be passed additionally. Currently only allocatable (bool) is supported.

        def node_storage_modify node_name, opts = {}
          request(
            :expects => 200,
            :method  => 'PUT',
            :query   => opts.delete(:query),
            :path    => "/2/nodes/#{node_name}/storage/modify"
          )
        end

      end

      class Mock

        def node_storage_modify node_name, opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
