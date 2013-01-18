module Fog
  module Compute
    class Ecloud

      class Real
        basic_request :get_ip_address
      end

			class Mock
        def get_ip_address(uri)

          network_id, ip_address_id = uri.match(/\/networks\/(\d+)\/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})$/).captures
          ip_address = self.data[:networks][network_id.to_i][:IpAddresses][:IpAddress].detect{|ip| ip[:name] == ip_address_id }.dup
          if ip_address
            response(:body => ip_address)
          else response(:status => 404) # ?
          end
        end
      end
    end
  end
end
