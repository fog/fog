module Fog
  module Vcloud
    class Compute
      module Shared
        private

        def validate_network_ip_data(network_ip_data)
          valid_opts = [:id, :href, :name, :status, :server]
          unless valid_opts.all? { |opt| network_ip_data.key?(opt) }
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
            :headers  => {'Content-Type' => 'application/vnd.vmware.vcloud.ip+xml' },
            :method   => 'PUT',
            :uri      => network_ip_uri,
            :parse    => true
          )
        end

        private

        def generate_configure_network_ip_request(network_ip_data)
          builder = Builder::XmlMarkup.new
          builder.IpAddress(xmlns) {
            builder.Id(network_ip_data[:id])
            builder.Href(network_ip_data[:href])
            builder.Name(network_ip_data[:name])
            builder.Status(network_ip_data[:status])
            builder.Server(network_ip_data[:server])
          }
        end
      end
    end
  end
end
