module Fog
  module Compute
    class Ecloud
      class Real
        include Shared

        def firewall_acls_create(data)
          validate_data([:permission, :protocol, :source, :destination], data)
          raise ArgumentError.new("Required data missing: source[:type] is required") unless data[:source][:type]
          raise ArgumentError.new("Required data missing: destination[:type] is required") unless data[:destination][:type]

          request(
            :body => generate_create_firewall_acls_request(data),
            :expects => 201,
            :method => "POST",
            :headers => {},
            :uri => data[:uri],
            :parse => true
          )
        end

        private

        def generate_create_firewall_acls_request(data)
          xml = Builder::XmlMarkup.new
          xml.CreateFirewallAcl do
            xml.Permission data[:permission]
            xml.Protocol data[:protocol]
            xml.Source do
              xml.Type data[:source][:type]
              if data[:source][:external_ip_address]
                xml.ExternalIpAddress data[:external_ip_address]
              end
              if data[:source][:external_network]
                xml.ExternalNetwork do
                  xml.Address data[:source][:external_network][:address]
                  xml.Size data[:source][:external_network][:size]
                end
              end
              if data[:source][:ip_address]
                xml.IpAddress(:href => data[:source][:ip_address])
              end
              if data[:source][:network]
                xml.Network(:href => data[:source][:network][:href], :name => data[:source][:network][:name])
              end
            end
            xml.Destination do
              xml.Type data[:destination][:type]
              if data[:destination][:external_ip_address]
                xml.ExternalIpAddress data[:external_ip_address]
              end
              if data[:destination][:external_network]
                xml.ExternalNetwork do
                  xml.Address data[:destination][:external_network][:address]
                  xml.Size data[:destination][:external_network][:size]
                end
              end
              if data[:destination][:ip_address]
                xml.IpAddress(:href => data[:destination][:ip_address])
              end
              if data[:destination][:network]
                xml.Network(:href => data[:destination][:network][:href], :name => data[:destination][:network][:name])
              end
            end
            xml.PortRange do
              if data[:port_range][:start]
                xml.Start data[:port_range][:start]
              end
              if data[:port_range][:end]
                xml.End data[:port_range][:end]
              end
            end
          end
        end
      end
    end
  end
end
