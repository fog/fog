module Fog
  module Compute
    class Ecloud
      class Real

        def validate_network_data(network_data, configure=false)
          valid_opts = [:id, :href, :name, :rnat, :address, :broadcast, :gateway]
          unless valid_opts.all? { |opt| network_data.has_key?(opt) }
            raise ArgumentError.new("Required data missing: #{(valid_opts - network_data.keys).map(&:inspect).join(", ")}")
          end
        end

        def configure_network(network_uri, network_data)
          validate_network_data(network_data)

          request(
            :body     => generate_configure_network_request(network_data),
            :expects  => 200,
            :headers  => {'Content-Type' => 'application/vnd.tmrk.ecloud.networkService+xml'},
            :method   => 'PUT',
            :uri      => network_uri,
            :parse    => true
          )
        end

        private

        def generate_configure_network_request(network_data)
          builder = Builder::XmlMarkup.new
          builder.Network(ecloud_xmlns) {
            builder.Id(network_data[:id])
            builder.Href(network_data[:href])
            builder.Name(network_data[:name])
            builder.RnatAddress(network_data[:rnat])
            builder.Address(network_data[:address])
            builder.BroadcastAddress(network_data[:broadcast])
            builder.GatewayAddress(network_data[:gateway])
          }
        end

      end
    end
  end
end
