  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a port forwarding rule
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createPortForwardingRule.html]
          def create_port_forwarding_rule(options={})
            options.merge!(
              'command' => 'createPortForwardingRule'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
