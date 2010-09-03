module Fog
  class Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :get_firewall_acls
        end

        module Mock
          def get_firewall_acls(firewall_acls_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
