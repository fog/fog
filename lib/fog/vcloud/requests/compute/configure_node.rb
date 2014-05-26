module Fog
  module Vcloud
    class Compute
      module Shared
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

      class Real
        include Shared

        def configure_node(node_uri, node_data)
          validate_node_data(node_data, true)

          request(
            :body     => generate_configure_node_request(node_data),
            :expects  => 200,
            :headers  => {'Content-Type' => 'application/vnd.vmware.vcloud.nodeService+xml'},
            :method   => 'PUT',
            :uri      => node_uri,
            :parse    => true
          )
        end
      end
    end
  end
end
