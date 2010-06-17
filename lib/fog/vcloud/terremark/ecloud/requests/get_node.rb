module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :get_node
        end

        module Mock
          def get_node(node_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
