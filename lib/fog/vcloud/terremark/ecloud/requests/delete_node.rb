module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :delete_node, 200, 'DELETE', {}, ""
        end

        module Mock

          def delete_node(node_uri)
            node_uri = ensure_unparsed(node_uri)

            node = mock_node_from_url(node_uri)
            service = mock_service_from_node_url(node_uri)
            if node and service
              service[:nodes].delete(node)
              mock_it 200, '', {}
            else
              mock_error 200, "401 Unauthorized"
            end
          end
        end
      end
    end
  end
end
