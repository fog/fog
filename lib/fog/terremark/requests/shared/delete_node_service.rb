module Fog
  module Terremark
    module Shared
      module Real

        # Destroy a node
        #
        # ==== Parameters
        # * node_service_id<~Integer> - Id of node to destroy
        #
        def delete_node_service(node_service_id)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "api/extensions/v1.6/nodeService/#{node_service_id}",
            :override_path => true
          )
        end

      end
    end
  end
end
