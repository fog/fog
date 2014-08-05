module Fog
  module Compute
    class Ecloud
      class Real
        include Shared

        def trusted_network_groups_edit(data)
          validate_data([:name], data)
          unless (data[:hosts] || data[:networks])
            raise ArgumentError.new("Required data missing: Either hosts or networks must be present")
          end

          request(
            :body => generate_edit_trusted_network_groups_request(data),
            :expects => 202,
            :method => "PUT",
            :headers => {},
            :uri => data[:uri],
            :parse => true
          )
        end

        private

        def generate_edit_trusted_network_groups_request(data)
          xml = Builder::XmlMarkup.new
          xml.TrustedNetworkGroup(:name => data[:name]) do
            if data[:hosts]
              xml.Hosts do
                data[:hosts].each do |ip|
                  xml.IpAddress ip
                end
              end
            end
            if data[:networks]
              xml.Networks do
                data[:networks].each do |network|
                  address, subnet = network.split('/')
                  xml.Network do
                    xml.Address address
                    xml.Size subnet
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
