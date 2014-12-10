module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def set_ssl_termination(load_balancer_id, securePort, privatekey, certificate, options = {})
          data = {
            :securePort => securePort,
            :privatekey => privatekey,
            :certificate => certificate
          }

          if options.key? :intermediate_certificate
            data['intermediateCertificate'] = options[:intermediate_certificate]
          end
          if options.key? :enabled
            data['enabled'] = options[:enabled]
          end
          if options.key? :secure_traffic_only
            data['secureTrafficOnly'] = options[:secure_traffic_only]
          end
          request(
            :body     => Fog::JSON.encode(data),
            :expects => [200, 202],
            :path => "loadbalancers/#{load_balancer_id}/ssltermination",
            :method => 'PUT'
          )
         end
      end
    end
  end
end
