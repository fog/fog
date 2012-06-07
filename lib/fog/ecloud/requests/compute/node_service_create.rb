module Fog
  module Compute
    class Ecloud
      module Shared
        def validate_node_service_data(service_data)
          required_opts = [:name, :port, :enabled, :ip_address]
          unless required_opts.all? { |opt| service_data.has_key?(opt) }
            raise ArgumentError.new("Required Internet Service data missing: #{(required_opts - service_data.keys).map(&:inspect).join(", ")}")
          end
        end
      end

      class Real
        include Shared

        def node_service_create(service_data)
          validate_node_service_data(service_data)

          request(
            :body => generate_node_service_request(service_data),
            :expects => 201,
            :method => "POST",
            :headers => {},
            :uri => service_data[:uri],
            :parse => true
          )
        end

        private

        def generate_node_service_request(service_data)
          xml = Builder::XmlMarkup.new
          xml.CreateNodeService(:name => service_data[:name]) do
            xml.IpAddress(:href => service_data[:ip_address], :name => service_data[:ip_address].scan(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)[0])
            xml.Port service_data[:port]
            xml.Enabled service_data[:enabled]
            if service_data[:description]
              xml.Description service_data[:description]
            end
          end
        end
      end
    end
  end
end          
