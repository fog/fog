module Fog
  class Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :get_firewall_acl
        end

        module Mock
          def get_firewall_acl(firewall_acl_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
