module Fog
  class Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :delete_internet_service, 200, 'DELETE', {}, ""
        end

        module Mock

          def delete_internet_service(service_uri)

            deleted = false
            if ip = mock_ip_from_service_url(service_uri)
              if service = ip[:services].detect { |service| service[:href] == service_uri }
                ip[:services].delete(service)
                deleted = true
              end
            end

            if deleted
              mock_it 200, '', { }
            else
              mock_error 200, "401 Unauthorized"
            end
          end
        end
      end
    end
  end
end

