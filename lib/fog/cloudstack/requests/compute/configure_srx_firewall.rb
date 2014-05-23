module Fog
  module Compute
    class Cloudstack

      class Real
        # Configures a SRX firewall device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/configureSrxFirewall.html]
        def configure_srx_firewall(options={})
          options.merge!(
            'command' => 'configureSrxFirewall',
            'fwdeviceid' => options['fwdeviceid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

