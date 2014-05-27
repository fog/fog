module Fog
  module Compute
    class Cloudstack

      class Real
        #  delete a SRX firewall device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteSrxFirewall.html]
        def delete_srx_firewall(options={})
          options.merge!(
            'command' => 'deleteSrxFirewall', 
            'fwdeviceid' => options['fwdeviceid']  
          )
          request(options)
        end
      end

    end
  end
end

