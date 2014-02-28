module Fog
  module Compute
    class Ecloud
      class Real
        include Shared

        def rnat_associations_create_device(data)
          validate_data([:host_ip_href, :public_ip_href], data)

          request(
            :body => generate_rnat_associations_create_device_request(data),
            :expects => 201,
            :method => "POST",
            :headers => {},
            :uri => data[:uri],
            :parse => true
          )
        end

        private

        def generate_rnat_associations_create_device_request(data)
          xml = Builder::XmlMarkup.new
          xml.CreateRnatAssociation do
            xml.PublicIp(:href => data[:public_ip_href])
            xml.IpAddress(:href => data[:host_ip_href])
          end
        end
      end
    end
  end
end
