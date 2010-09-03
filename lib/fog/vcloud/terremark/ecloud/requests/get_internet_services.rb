module Fog
  class Vcloud
    module Terremark
      module Ecloud

        module Real
          basic_request :get_internet_services
        end

        module Mock

          #
          #Based off of:
          #http://support.theenterprisecloud.com/kb/default.asp?id=580&Lang=1&SID=
          #http://support.theenterprisecloud.com/kb/default.asp?id=560&Lang=1&SID=
          #
          #
          def self.internet_services_for_ip(xml,ip)
            ip[:services].each do |service|
              xml.InternetService {
                xml.Id(service[:id])
                xml.Href(Fog::Vcloud::Terremark::Ecloud::Mock.internet_service_href(service))
                xml.Name(service[:name])
                xml.PublicIpAddress {
                  xml.Id(ip[:id])
                  xml.Href(Fog::Vcloud::Terremark::Ecloud::Mock.public_ip_href(ip))
                  xml.Name(ip[:name])
                }
                xml.Port(service[:port])
                xml.Protocol(service[:protocol])
                xml.Enabled(service[:enabled])
                xml.Timeout(service[:timeout])
                xml.Description(service[:description])
                xml.RedirectURL(service[:redirect_url])
                xml.Monitor
              }
            end
          end

          def get_internet_services(internet_services_uri)
            internet_services_uri = ensure_unparsed(internet_services_uri)
            xml = nil
            builder = Builder::XmlMarkup.new
            if vdc = vdc_from_uri(internet_services_uri)
              xml = builder.InternetServices( :xmlns => "urn:tmrk:eCloudExtensions-2.3",:"xmlns:i" => "http://www.w3.org/2001/XMLSchema-instance" ) { |xml|
                vdc[:public_ips].each do |ip|
                  Fog::Vcloud::Terremark::Ecloud::Mock.internet_services_for_ip(xml,ip)
                end
              }
            elsif ip = ip_from_uri(internet_services_uri)
              xml = builder.InternetServices( :xmlns => "urn:tmrk:eCloudExtensions-2.3",:"xmlns:i" => "http://www.w3.org/2001/XMLSchema-instance" ) { |xml|
                Fog::Vcloud::Terremark::Ecloud::Mock.internet_services_for_ip(xml,ip)
              }
            end
            if xml
              mock_it 200,
                xml, { 'Content-Type' => 'application/vnd.tmrk.ecloud.internetServicesList+xml' }
            else
              mock_error 200, "401 Unauthorized"
            end
          end
        end
      end
    end
  end
end
