module Fog
  module Vcloud
    module Terremark
      module Ecloud
        module Real

          def generate_configure_internet_service_request(service_data,ip_address_data)
            builder = Builder::XmlMarkup.new
            builder.InternetService(:"xmlns:i" => "http://www.w3.org/2001/XMLSchema-instance",
                                    :xmlns => "urn:tmrk:eCloudExtensions-2.3") {
              builder.Id(service_data[:id])
              builder.Href(service_data[:href].to_s)
              builder.Name(service_data[:name])
              builder.Protocol(service_data[:protocol])
              builder.Port(service_data[:port])
              builder.Enabled(service_data[:enabled])
              builder.Description(service_data[:description])
              builder.Timeout(service_data[:timeout])
              builder.RedirectURL(service_data[:redirect_url])
              builder.PublicIpAddress {
                builder.Id(ip_address_data[:id])
                builder.Href(ip_address_data[:href].to_s)
                builder.Name(ip_address_data[:name])
              }
            }
          end

          def validate_public_ip_address_data(ip_address_data)
            valid_opts = [:name, :href, :id]
            unless valid_opts.all? { |opt| ip_address_data.keys.include?(opt) }
              raise ArgumentError.new("Required Internet Service data missing: #{(valid_opts - ip_address_data.keys).map(&:inspect).join(", ")}")
            end
          end

          def configure_internet_service(internet_service_uri, service_data, ip_address_data)
            validate_internet_service_data(service_data, true)

            validate_public_ip_address_data(ip_address_data)

            request(
              :body     => generate_configure_internet_service_request(service_data, ip_address_data),
              :expects  => 200,
              :headers  => {'Content-Type' => 'application/vnd.tmrk.ecloud.internetService+xml'},
              :method   => 'PUT',
              :uri      => internet_service_uri,
              :parse    => true
            )
          end

        end

        module Mock
          #
          # Based on
          # http://support.theenterprisecloud.com/kb/default.asp?id=583&Lang=1&SID=
          #

          def configure_internet_service(internet_service_uri, service_data, ip_address_data)
            validate_internet_service_data(service_data, true)

            validate_public_ip_address_data(ip_address_data)

            internet_service_uri = ensure_unparsed(internet_service_uri)

            found = false
            xml = nil
            if ip = ip_from_uri(ip_address_data[:href])
              if service = ip[:services].detect { |service| service[:id] == internet_service_uri.split('/')[-1] }
                found = true
                ip[:services][ip[:services].index(service)] = service_data

                builder = Builder::XmlMarkup.new
                xml = builder.InternetService(:xmlns => "urn:tmrk:eCloudExtensions-2.0",
                                              :"xmlns:i" => "http://www.w3.org/2001/XMLSchema-instance") {
                  builder.Id(service_data[:id])
                  builder.Href(Fog::Vcloud::Terremark::Ecloud::Mock.internet_service_href(service_data))
                  builder.Name(service_data[:name])
                  builder.PublicIpAddress {
                    builder.Id(ip[:id])
                    builder.Href(Fog::Vcloud::Terremark::Ecloud::Mock.public_ip_href(ip))
                    builder.Name(ip[:name])
                  }
                  builder.Protocol(service_data[:protocol])
                  builder.Port(service_data[:port])
                  builder.Enabled(service_data[:enabled])
                  builder.Description(service_data[:description])
                  builder.Timeout(service_data[:timeout])
                }
              end
            end
            if found
              mock_it 200, xml, {'Content-Type' => 'application/vnd.tmrk.ecloud.internetService+xml'}
            else
              mock_error 200, "401 Unauthorized"
            end
          end
        end
      end
    end
  end
end

