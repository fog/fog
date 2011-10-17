module Fog
  module Compute
    class Ecloud
      module Shared
        private

        def validate_public_ip_address_data(ip_address_data)
          valid_opts = [:name, :href, :id]
          unless valid_opts.all? { |opt| ip_address_data.keys.include?(opt) }
            raise ArgumentError.new("Required Internet Service data missing: #{(valid_opts - ip_address_data.keys).map(&:inspect).join(", ")}")
          end
        end
      end

      class Real
        include Shared

        def configure_internet_service(internet_service_uri, service_data, ip_address_data)
          validate_internet_service_data(service_data, true)

          validate_public_ip_address_data(ip_address_data)

          if monitor = service_data[:monitor]
            validate_internet_service_monitor(monitor)
            ensure_monitor_defaults!(monitor)
          end

          request(
            :body     => generate_configure_internet_service_request(service_data, ip_address_data),
            :expects  => 200,
            :headers  => {'Content-Type' => 'application/vnd.tmrk.ecloud.internetService+xml'},
            :method   => 'PUT',
            :uri      => internet_service_uri,
            :parse    => true
          )
        end

        private

        def generate_configure_internet_service_request(service_data, ip_address_data)
          builder = Builder::XmlMarkup.new
          builder.InternetService(ecloud_xmlns) {
            builder.Id(service_data[:id])
            builder.Href(service_data[:href])
            builder.Name(service_data[:name])
            builder.Protocol(service_data[:protocol])
            builder.Port(service_data[:port])
            builder.Enabled(service_data[:enabled])
            builder.Description(service_data[:description])
            builder.Timeout(service_data[:timeout])
            builder.RedirectURL(service_data[:redirect_url])
            builder.PublicIpAddress {
              builder.Id(ip_address_data[:id])
              builder.Href(ip_address_data[:href])
              builder.Name(ip_address_data[:name])
            }
            if monitor = service_data[:monitor]
              generate_monitor_section(builder, monitor)
            end
            if service_data[:backup_service_uri]
              builder.BackupService do
                builder.Href(service_data[:backup_service_uri])
              end
            end
          }
        end
      end

      class Mock
        include Shared

        #
        # Based on
        # http://support.theenterprisecloud.com/kb/default.asp?id=583&Lang=1&SID=
        #

        def configure_internet_service(internet_service_uri, service_data, ip_address_data)
          service_data = service_data.dup

          validate_internet_service_data(service_data, true)

          if monitor = service_data[:monitor]
            validate_internet_service_monitor(monitor)
            ensure_monitor_defaults!(monitor)
          end

          validate_public_ip_address_data(ip_address_data)

          internet_service_uri = ensure_unparsed(internet_service_uri)

          backup_service_uri = service_data.delete(:backup_service_uri)
          backup_service = backup_service_uri && mock_data.backup_internet_service_from_href(backup_service_uri)

          xml = nil

          if (public_ip_internet_service = mock_data.public_ip_internet_service_from_href(internet_service_uri)) &&
              (backup_service_uri.nil? || backup_service)
            public_ip_internet_service.update(service_data.reject {|k, v| [:id, :href].include?(k) })
            public_ip_internet_service[:backup_service] = backup_service
            xml = generate_internet_service(Builder::XmlMarkup.new, public_ip_internet_service, true)
          end

          if xml
            mock_it 200, xml, {'Content-Type' => 'application/vnd.tmrk.ecloud.internetService+xml'}
          else
            mock_error 200, "401 Unauthorized"
          end
        end
      end
    end
  end
end
