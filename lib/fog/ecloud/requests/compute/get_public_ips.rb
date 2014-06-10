module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_public_ips
      end

      class Mock
        def get_public_ips(uri)
          environment_id = id_from_uri(uri)
          environment    = self.data[:environments][environment_id]

          public_ips  = self.data[:public_ips].values.select{|cp| cp[:environment_id] == environment_id}

          public_ips = public_ips.map{|pi| Fog::Ecloud.slice(pi, :id, :environment_id)}

          public_ip_response = {:PublicIp => (public_ips.size > 1 ? public_ips : public_ips.first)} # GAH
          body = {
            :href  => uri,
            :type  => "application/vnd.tmrk.cloud.publicIp; type=collection",
            :Links => {
              :Link => environment,
            }
          }.merge(public_ip_response)

          response(:body => body)
        end
      end
    end
  end
end
