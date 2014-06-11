module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_internet_services
      end

      class Mock
        def get_internet_services(uri)
          public_ip_id = id_from_uri(uri)
          public_ip    = self.data[:public_ips][public_ip_id]

          response(:body => Fog::Ecloud.slice(public_ip, :environment_id))
        end
      end
    end
  end
end
