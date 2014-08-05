module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_node
      end

      class Mock
        def get_node(uri)
          node_service_id = id_from_uri(uri)
          node_service    = self.data[:node_services][node_service_id.to_i]

          if node_service
            response(:body => Fog::Ecloud.slice(node_service, :id, :internet_service_id))
          else raise Fog::Errors::NotFound
          end
        end
      end
    end
  end
end
