module Fog
  module Vcloud
    module Terremark
      module Ecloud
        module Real

          def generate_internet_service_request(service_data)
            builder = Builder::XmlMarkup.new
            builder.CreateInternetServiceRequest(:"xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                                                 :"xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
                                                 :xmlns => "urn:tmrk:eCloudExtensions-2.3") {
              builder.Name(service_data[:name])
              builder.Protocol(service_data[:protocol])
              builder.Port(service_data[:port])
              builder.Enabled(service_data[:enabled])
              builder.Description(service_data[:description])
              builder.RedirectUrl(service_data[:redirect_url])
              #builder.Monitor {
              #  builder.MonitorType {}
              #  builder.UrlSendString {}
              #  builder.HttpHeader {}
              #  builder.ReceiveString {}
              #  builder.Interval {}
              #  builder.ResponseTimeOut {}
              #  builder.DownTime {}
              #  builder.Retries {}
              #  builder.IsEnabled {}
              #}
            }
          end

          def validate_internet_service_data(service_data, configure=false)
            valid_opts = [:name, :protocol, :port, :description, :enabled, :redirect_url]
            if configure
              valid_opts + [ :id, :href, :timeout ]
            end
            unless valid_opts.all? { |opt| service_data.keys.include?(opt) }
              raise ArgumentError.new("Required Internet Service data missing: #{(valid_opts - service_data.keys).map(&:inspect).join(", ")}")
            end
          end

          def add_internet_service(internet_services_uri, service_data)
            validate_internet_service_data(service_data)

            request(
              :body     => generate_internet_service_request(service_data),
              :expects  => 200,
              :headers  => {'Content-Type' => 'application/vnd.tmrk.ecloud.internetService+xml'},
              :method   => 'POST',
              :uri      => internet_services_uri,
              :parse    => true
            )
          end

        end

        module Mock
          #
          # Based on
          # http://support.theenterprisecloud.com/kb/default.asp?id=561&Lang=1&SID=
          #

          def add_internet_service(internet_services_uri, service_data)
            validate_internet_service_data(service_data)

            internet_services_uri = ensure_unparsed(internet_services_uri)

            if ip = ip_from_uri(internet_services_uri)
              new_service = service_data.merge!( { :id => rand(1000), :timeout => 2 } )
              ip[:services] << new_service
              builder = Builder::XmlMarkup.new
              xml = builder.InternetService(:xmlns => "urn:tmrk:eCloudExtensions-2.0",
                                            :"xmlns:i" => "http://www.w3.org/2001/XMLSchema-instance") {
                builder.Id(new_service[:id])
                builder.Href(Fog::Vcloud::Terremark::Ecloud::Mock.internet_service_href(new_service))
                builder.Name(new_service[:name])
                builder.PublicIpAddress {
                  builder.Id(ip[:id])
                  builder.Href(Fog::Vcloud::Terremark::Ecloud::Mock.public_ip_href(ip))
                  builder.Name(ip[:name])
                }
                builder.Protocol(new_service[:protocol])
                builder.Port(new_service[:port])
                builder.Enabled(new_service[:enabled])
                builder.Description(new_service[:description])
                builder.Timeout(new_service[:timeout])
              }

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

