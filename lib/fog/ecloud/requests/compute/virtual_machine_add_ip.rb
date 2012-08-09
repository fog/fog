module Fog
  module Compute
    class Ecloud
      module Shared

        def build_request_body_add_ip(networks)
          xml = Builder::XmlMarkup.new
          xml.AssignedIpAddresses do
            xml.Networks do
              networks.each do |network|
                xml.Network(:href => network[:href], :type => network[:type]) do
                  xml.IpAddresses do
                    network[:ips].each do |ip|
                      xml.IpAddress ip
                    end
                  end
                end
              end
            end
          end    
        end
      end

      class Real

        def virtual_machine_add_ip(href, options)
          body = build_request_body_add_ip(options)
          request(
            :expects => 202,
            :method => 'PUT',
            :headers => {},
            :body => body,
            :uri => href,
            :parse => true
          )
        end
      end
    end
  end
end
