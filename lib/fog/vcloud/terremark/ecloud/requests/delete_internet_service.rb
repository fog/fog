module Fog
  module Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :delete_internet_service, 200, 'DELETE', {}, ""
        end

        module Mock

          def delete_internet_service(service_uri)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end

