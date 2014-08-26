module Fog
  module Compute
    class Cloudstack

      class Real
        #  delete a Palo Alto firewall device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deletePaloAltoFirewall.html]
        def delete_palo_alto_firewall(options={})
          request(options)
        end


        def delete_palo_alto_firewall(fwdeviceid, options={})
          options.merge!(
            'command' => 'deletePaloAltoFirewall', 
            'fwdeviceid' => fwdeviceid  
          )
          request(options)
        end
      end

    end
  end
end

