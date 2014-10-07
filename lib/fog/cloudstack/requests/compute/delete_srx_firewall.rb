module Fog
  module Compute
    class Cloudstack

      class Real
        #  delete a SRX firewall device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteSrxFirewall.html]
        def delete_srx_firewall(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteSrxFirewall') 
          else
            options.merge!('command' => 'deleteSrxFirewall', 
            'fwdeviceid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

