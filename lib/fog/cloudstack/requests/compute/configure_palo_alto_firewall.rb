module Fog
  module Compute
    class Cloudstack

      class Real
        # Configures a Palo Alto firewall device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/configurePaloAltoFirewall.html]
        def configure_palo_alto_firewall(options={})
          request(options)
        end


        def configure_palo_alto_firewall(fwdeviceid, options={})
          options.merge!(
            'command' => 'configurePaloAltoFirewall', 
            'fwdeviceid' => fwdeviceid  
          )
          request(options)
        end
      end

    end
  end
end

