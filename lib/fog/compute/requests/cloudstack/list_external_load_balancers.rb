module Fog
  module Compute
    class Cloudstack
      class Real

        def list_external_load_balancers(options={})
          options.merge!(
            'command' => 'listExternalLoadBalancers'
          )
          
          request(options)
        end

      end
    end
  end
end
