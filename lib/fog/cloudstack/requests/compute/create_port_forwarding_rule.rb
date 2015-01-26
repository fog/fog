module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a port forwarding rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createPortForwardingRule.html]
        def create_port_forwarding_rule(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createPortForwardingRule')
          else
            options.merge!('command' => 'createPortForwardingRule',
            'virtualmachineid' => args[0],
            'protocol' => args[1],
            'privateport' => args[2],
            'ipaddressid' => args[3],
            'publicport' => args[4])
          end
          request(options)
        end
      end

    class Mock
      def create_port_forwarding_rule(*args)
        port_forwarding_rule_id = "43192143-5828-6831-58286837474"
        port_forwarding_rule = {
          'id'                      => port_forwarding_rule_id,
          'privateport' => "110",
          'privateendport' => "110",
          'protocol' => "tcp",
          'publicport' => "111",
          'publicendport' => "111",
          'virtualmachineid' => "8f4627c5-1fdd-4504-8a92-f61b4e9cb3e3",
          'virtualmachinename' => "Pop3LoadBalancer",
          'virtualmachinedisplayname' => "Pop3LoadBalancer",
          'ipaddressid' => "f1f1f1f1-f1f1-f1f1-f1f1-f1f1f1f1f1",
          'ipaddress' => "192.168.200.201",
          'state' => "Active",
          'cidrlist' => "",
          'tags' => []
        }

        self.data[:port_forwarding_rules][port_forwarding_rule_id]= port_forwarding_rule
        {'createportforwardingruleresponse' => port_forwarding_rule}

      end
    end

    end
  end
end

