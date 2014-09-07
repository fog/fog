module Fog
  module Compute
    class Cloudstack

      class Real
        #  delete a Palo Alto firewall device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deletePaloAltoFirewall.html]
        def delete_palo_alto_firewall(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deletePaloAltoFirewall') 
          else
            options.merge!('command' => 'deletePaloAltoFirewall', 
            'fwdeviceid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

