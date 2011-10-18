module Fog
  module Compute
    class Ecloud
      module Shared
        def validate_backup_internet_service_data(service_data, configure=false)
          required_opts = [:name, :protocol, :description, :enabled]
          if configure
            required_opts + [ :id, :href, :timeout ]
          end
          unless required_opts.all? { |opt| service_data.keys.include?(opt) }
            raise ArgumentError.new("Required Backup Internet Service data missing: #{(required_opts - service_data.keys).map(&:inspect).join(", ")}")
          end
        end
      end

      class Real
        include Shared

        def add_backup_internet_service(internet_services_uri, service_data)
          validate_backup_internet_service_data(service_data)
          if monitor = service_data[:monitor]
            validate_internet_service_monitor(monitor)
            ensure_monitor_defaults!(monitor)
          end

          request(
            :body     => generate_backup_internet_service_request(service_data),
            :expects  => 200,
            :headers  => {'Content-Type' => 'application/xml'},
            :method   => 'POST',
            :uri      => internet_services_uri,
            :parse    => true
          )
        end

        private

        def generate_backup_internet_service_request(service_data)
          builder = Builder::XmlMarkup.new
          builder.CreateBackupInternetServiceRequest("xmlns" => "urn:tmrk:eCloudExtensions-2.5") {
            builder.Name(service_data[:name])
            builder.Protocol(service_data[:protocol])
            builder.Enabled(service_data[:enabled])
            builder.Description(service_data[:description])
            builder.RedirectURL(service_data[:redirect_url])
            if monitor = service_data[:monitor]
              generate_monitor_section(builder,monitor)
            end
          }
        end
      end

      class Mock
        include Shared

        #
        # Based on
        # http://support.theenterprisecloud.com/kb/default.asp?id=729&Lang=1&SID=
        # and many tears shed.
        #

        def add_backup_internet_service(internet_services_uri, service_data)
          validate_backup_internet_service_data(service_data)

          internet_services_uri = ensure_unparsed(internet_services_uri)

          if vdc_internet_service_collection = mock_data.vdc_internet_service_collection_from_href(internet_services_uri)
            new_backup_internet_service = MockBackupInternetService.new(service_data, vdc_internet_service_collection.backup_internet_services)
            vdc_internet_service_collection.backup_internet_services << new_backup_internet_service
            xml = generate_backup_internet_service_added_response(new_backup_internet_service)

            mock_it 200, xml, {'Content-Type' => 'application/vnd.tmrk.ecloud.internetService+xml'}
          else
            mock_error 200, "401 Unauthorized"
          end
        end

        private

        def generate_backup_internet_service_added_response(new_backup_internet_service)
          builder = Builder::XmlMarkup.new
          builder.InternetService("xmlns" => "urn:tmrk:eCloudExtensions-2.5", "xmlns:i" => "http://www.w3.org/2001/XMLSchema-instance") {
            builder.Id new_backup_internet_service.object_id
            builder.Href new_backup_internet_service.href
            builder.Name new_backup_internet_service.name
            # so broken
            builder.PublicIpAddress do
              builder.Id -2147483648
              builder.Id "http://totally.invalid/1234"
              builder.Name
            end
            builder.Port new_backup_internet_service.port
            builder.Protocol new_backup_internet_service.protocol
            builder.Enabled new_backup_internet_service.enabled
            builder.Timeout new_backup_internet_service.timeout
            builder.Description new_backup_internet_service.description
            builder.RedirectURL new_backup_internet_service.redirect_url
            builder.Monitor "i:nil" => true
            # so broken
            builder.IsBackupService false
            builder.BackupService "i:nil" => true
            builder.BackupOf "i:nil" => true
          }
        end
      end
    end
  end
end

