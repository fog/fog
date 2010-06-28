module Fog
  module Vcloud
    module Terremark
      module Ecloud
        module Real

          def add_node(nodes_uri, node_data)
            validate_node_data(node_data)

            request(
              :body     => generate_node_request(node_data),
              :expects  => 200,
              :headers  => {'Content-Type' => 'application/vnd.tmrk.ecloud.nodeService+xml'},
              :method   => 'POST',
              :uri      => nodes_uri,
              :parse    => true
            )
          end

          private

          def generate_node_request(node_data)
            builder = Builder::XmlMarkup.new
            builder.CreateNodeServiceRequest(:"xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                                             :"xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
                                             :xmlns => "urn:tmrk:eCloudExtensions-2.3") {
              builder.IpAddress(node_data[:ip_address])
              builder.Name(node_data[:name])
              builder.Port(node_data[:port])
              builder.Enabled(node_data[:enabled])
              builder.Description(node_data[:description])
            }
          end

          def validate_node_data(node_data, configure=false)
            valid_opts = [:name, :port, :enabled, :description, :ip_address]
            if configure
              valid_opts.delete_if { |opt| ![:name, :enabled, :description].include?(opt) }
            end
            unless valid_opts.all? { |opt| node_data.keys.include?(opt) }
              raise ArgumentError.new("Required data missing: #{(valid_opts - node_data.keys).map(&:inspect).join(", ")}")
            end
          end
        end

        module Mock

          def add_node(nodes_uri, node_data)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
