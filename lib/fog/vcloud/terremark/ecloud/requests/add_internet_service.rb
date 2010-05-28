module Fog
  module Vcloud
    module Terremark
      module Ecloud
        module Real

          def self.generate_internet_service_request(service_data)
            builder = Builder::XmlMarkup.new
            builder.CreateInternetServiceRequest(:"xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                                                 :"xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
                                                 :xmlns => "urn:tmrk:eCloudExtensions-2.0") {
              builder.Name(service_data[:name])
              builder.Protocol(service_data[:protocol])
              builder.Port(service_data[:port])
              builder.Enabled(service_data[:enabled])
              builder.Description(service_data[:description])
            }
          end

          def self.validate_internet_service_request_data(service_data)
            valid_opts = [:name, :protocol, :port, :description, :enabled, :description]
            unless valid_opts.all? { |opt| service_data.keys.include?(opt) }
              raise ArgumentError.new("Required Internet Service data missing: #{(valid_opts - service_data.keys).map(&:inspect).join(", ")}")
            end
          end

          def add_internet_service(internet_service_uri, service_data)
            Fog::Vcloud::Terremark::Ecloud::Real.validate_internet_service_request_data(service_data)

            request(
              :body     => Fog::Vcloud::Terremark::Ecloud::Real.generate_internet_service_request(service_data),
              :expects  => 200,
              :headers  => {'Content-Type' => 'application/vnd.tmrk.ecloud.internetService+xml'},
              :method   => 'POST',
              :parser   => Fog::Parsers::Vcloud::Terremark::Ecloud::InternetService.new,
              :uri      => internet_service_uri
            )
          end

        end

        module Mock
          #
          # Based on
          # http://support.theenterprisecloud.com/kb/default.asp?id=561&Lang=1&SID=
          #

          def add_internet_service(internet_service_uri, service_data)
            Fog::Vcloud::Terremark::Ecloud::Real.validate_internet_service_request_data(service_data)

            if ip = Fog::Vcloud::Mock.ip_from_uri(internet_service_uri.to_s)
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

              mock_it Fog::Parsers::Vcloud::Terremark::Ecloud::InternetService.new, 200, xml, {'Content-Type' => 'application/vnd.tmrk.ecloud.internetService+xml'}
            else
              mock_error 200, "401 Unauthorized"
            end
          end
        end
      end
    end
  end
end

