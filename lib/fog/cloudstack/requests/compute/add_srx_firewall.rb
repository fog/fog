module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a SRX firewall device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addSrxFirewall.html]
        def add_srx_firewall(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addSrxFirewall') 
          else
            options.merge!('command' => 'addSrxFirewall', 
            'username' => args[0], 
            'networkdevicetype' => args[1], 
            'physicalnetworkid' => args[2], 
            'password' => args[3], 
            'url' => args[4])
          end
          request(options)
        end
      end

    end
  end
end

