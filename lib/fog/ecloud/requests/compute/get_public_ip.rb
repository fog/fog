module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_public_ip
      end

      class Mock
        def get_public_ip(uri)
          public_ip_id = id_from_uri(uri)
          public_ip    = self.data[:public_ips][public_ip_id]

          if public_ip
            response(:body => Fog::Ecloud.slice(public_ip, :id, :environment_id))
          else raise Fog::Errors::NotFound
          end
        end
      end
    end
  end
end
