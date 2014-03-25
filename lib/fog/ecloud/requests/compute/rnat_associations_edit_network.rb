module Fog
  module Compute
    class Ecloud
      class Real
        include Shared

        def rnat_associations_edit_network(data)
          validate_data([:href], data)

          request(
            :body => generate_rnat_associations_edit_network_request(data),
            :expects => 202,
            :method => "PUT",
            :headers => {},
            :uri => data[:uri],
            :parse => true
          )
        end

        private

        def generate_rnat_associations_edit_network_request(data)
          xml = Builder::XmlMarkup.new
          xml.NetworkRnat do
            xml.Rnat(:href => data[:href])
          end
        end
      end
    end
  end
end
