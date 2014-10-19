module Fog
  module Compute
    class Cloudstack

      class Real
        # Configures a Palo Alto firewall device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/configurePaloAltoFirewall.html]
        def configure_palo_alto_firewall(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'configurePaloAltoFirewall') 
          else
            options.merge!('command' => 'configurePaloAltoFirewall', 
            'fwdeviceid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

