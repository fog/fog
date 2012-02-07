module Fog
  module Compute
    class Ecloud
      module Shared
        private

        def validate_network_ip_data(network_ip_data)
          valid_opts = [:id, :href, :name, :status, :server, :rnat]
          unless valid_opts.all? { |opt| network_ip_data.has_key?(opt) }
            raise ArgumentError.new("Required data missing: #{(valid_opts - network_ip_data.keys).map(&:inspect).join(", ")}")
          end
        end
      end

      class Real
        include Shared

        def configure_network_ip(network_ip_uri, network_ip_data)
          validate_network_ip_data(network_ip_data)

          request(
            :body     => generate_configure_network_ip_request(network_ip_data),
            :expects  => 200,
            :headers  => {'Content-Type' => 'application/vnd.tmrk.ecloud.ip+xml' },
            :method   => 'PUT',
            :uri      => network_ip_uri,
            :parse    => true
          )
        end

        private

        def generate_configure_network_ip_request(network_ip_data)
          builder = Builder::XmlMarkup.new
          builder.IpAddress(ecloud_xmlns) {
            builder.Id(network_ip_data[:id])
            builder.Href(network_ip_data[:href])
            builder.Name(network_ip_data[:name])
            builder.Status(network_ip_data[:status])
            builder.Server(network_ip_data[:server])
            builder.RnatAddress(network_ip_data[:rnat])
          }
        end
      end

      class Mock
        include Shared

        def configure_network_ip(network_ip_uri, network_ip_data)
          validate_network_ip_data(network_ip_data)

          if network_ip = mock_data.network_ip_from_href(network_ip_uri)
            network_ip[:rnat] = network_ip_data[:rnat]

            builder = Builder::XmlMarkup.new
            xml = network_ip_response(builder, network_ip, ecloud_xmlns)

            mock_it 200, xml, { 'Content-Type' => 'application/vnd.tmrk.ecloud.ip+xml' }
          else
            mock_error 200, "401 Unauthorized"
          end
        end
      end
    end
  end
end
