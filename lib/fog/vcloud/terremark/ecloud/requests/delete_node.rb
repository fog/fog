module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :delete_node, 200, 'DELETE', {}, ""
        end

        module Mock

          def delete_node(node_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
