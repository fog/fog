  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a port forwarding rule
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deletePortForwardingRule.html]
          def delete_port_forwarding_rule(options={})
            options.merge!(
              'command' => 'deletePortForwardingRule'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
