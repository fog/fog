module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a domain.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/createPortForwardingRule.html]
        def create_port_forwarding_rule(options={})
          options.merge!(
            'command' => 'createPortForwardingRule'
          )

          request(options)
        end

      end
    end
  end
end
