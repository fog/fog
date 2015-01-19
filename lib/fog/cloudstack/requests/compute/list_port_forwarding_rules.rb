module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all port forwarding rules for an IP address.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listPortForwardingRules.html]
        def list_port_forwarding_rules(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listPortForwardingRules')
          else
            options.merge!('command' => 'listPortForwardingRules')
          end

          # add project id if we have one
          @cloudstack_project_id ? options.merge!('projectid' => @cloudstack_project_id) : nil

          request(options)
        end
      end

      class Mock
        def list_port_forwarding_rules(*args)
          port_forwarding_rules = self.data[:port_forwarding_rules]
          {
            'listportforwardingrulesresponse' => {
              'count' => port_forwarding_rules.size,
              'portforwardingrule' => port_forwarding_rules.values
            }
          }
        end
      end

    end
  end
end

