module Fog
  module Vcloud
    module Terremark
      module Ecloud
        module Real

          def delete_internet_service(internet_service_uri)
            request(
              :body     => "",
              :expects  => 200,
              #:headers  => {'Content-Type' => 'application/vnd.tmrk.ecloud.internetService+xml'},
              :method   => 'DELETE',
              :uri      => internet_service_uri
            )
          end

        end

        module Mock
          #
          # Based on
          # http://support.theenterprisecloud.com/kb/default.asp?id=561&Lang=1&SID=
          #

          def delete_internet_service(internet_service_uri)
            if service = Fog::Vcloud::Mock.data[:organizations].map { |org| org[:vdcs].map { |vdc| vdc[:public_ips].map { |public_ip| public_ip[:services].map { |service| service } } } }.
              flatten.detect { |service| service[:id].to_s == internet_service_uri.to_s.split('/')[-1] }
              Fog::Vcloud::Mock.data[:organizations].map { |org| org[:vdcs].map { |vdc| vdc[:public_ips].map { |public_ip| public_ip[:services].delete(service) } } }
              mock_it nil, 200, "", {}
            else
              mock_error 200, "401 Unauthorized"
            end
          end
        end
      end
    end
  end
end

