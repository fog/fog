module Fog
  module Vcloud
    module Terremark
      module Ecloud
        module Real

          def configure_node(node_uri, node_data)
            validate_node_data(node_data, true)

            request(
              :body     => generate_configure_node_request(node_data),
              :expects  => 200,
              :headers  => {'Content-Type' => 'application/vnd.tmrk.ecloud.nodeService+xml'},
              :method   => 'PUT',
              :uri      => node_uri,
              :parse    => true
            )
          end

          private

          def generate_configure_node_request(node_data)
            builder = Builder::XmlMarkup.new
            builder.NodeService(:"xmlns:i" => "http://www.w3.org/2001/XMLSchema-instance",
                                    :xmlns => "urn:tmrk:eCloudExtensions-2.0") {
              builder.Name(node_data[:name])
              builder.Enabled(node_data[:enabled].to_s)
              builder.Description(node_data[:description])
            }
          end

        end

        module Mock

          def configure_node(node_uri, node_data)
            Fog::Mock.not_implemented
          end
        end
      end
    end
  end
end
