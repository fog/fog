module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes an external firewall appliance.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteExternalFirewall.html]
        def delete_external_firewall(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteExternalFirewall') 
          else
            options.merge!('command' => 'deleteExternalFirewall', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

