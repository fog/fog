module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def set_ssl_termination(load_balancer_id, securePort, privatekey, certificate, enabled, secureTrafficOnly)
          data = {
            securePort: securePort,
            privatekey: privatekey,
            certificate: certificate,
            #intermediatecertificate: intermediatecertificate
          }
          request(
            :body     => MultiJson.encode(data),
            :expects => [202,404],
            :path => "loadbalancers/#{load_balancer_id}/ssltermination",
            :method => 'PUT'
          )
         end
      end
    end
  end
end