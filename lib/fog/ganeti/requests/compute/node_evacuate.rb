module Fog
  module Ganeti
    class Compute
      class Real

        ##
        # Evacuates all secondary instances off a node.
        #
        # To evacuate a node, either one of the iallocator or remote_node parameters must be passed:
        #   - evacuate?iallocator=[iallocator]
        #   - evacuate?remote_node=[nodeX.example.com]
        # See: http://docs.ganeti.org/ganeti/2.2/html/rapi.html#nodes-node-name-evacuate
        #
        # If the optional dry-run parameter (?dry-run=1) is provided,
        # the job will not be actually executed, only the pre-execution
        # checks will be done.

        def node_list node_name
          request(
            :expects => 200,
            :method  => 'POST',
            :query   => opts.delete(:query),
            :path    => "/2/nodes/#{node_name}/evacuate"
          )
        end

      end

      class Mock

        def nodes_list node_name
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
