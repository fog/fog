module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :get_nodes
        end

        module Mock
          def get_nodes(nodes_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
