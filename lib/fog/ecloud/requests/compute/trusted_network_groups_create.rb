module Fog
  module Compute
    class Ecloud

      class Real
        include Shared

        def trusted_network_groups_create(data)
          validate_data([:name], data)
          unless (data[:hosts] || data[:networks])
            raise ArgumentError.new("Required data missing: Either hosts or networks must be present")
          end
          

          request(
            :body => generate_create_trusted_network_groups_request(data),
            :expects => 201,
            :method => "POST",
            :headers => {},
            :uri => data[:uri],
            :parse => true
          )
        end

        private

        def generate_create_trusted_network_groups_request(data)
          xml = Builder::XmlMarkup.new
          xml.CreateTrustedNetworkGroup(:name => data[:name]) do
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
