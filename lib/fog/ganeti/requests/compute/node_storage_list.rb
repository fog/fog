module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Requests a list of storage units on a node.
        # Returns a job id.
        #
        # Requires the parameters storage_type (one of file, lvm-pv or lvm-vg) and output_fields.

        def node_storage_list node_name, opts = {}
          request(
            :expects => 200,
            :method  => 'GET',
            :query   => opts.delete(:query),
            :path    => "/2/nodes/#{node_name}/storage"
          )
        end

      end

      class Mock

        def node_storage_list node_name, opts = {}
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
