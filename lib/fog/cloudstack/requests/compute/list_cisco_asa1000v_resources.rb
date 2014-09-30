module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists Cisco ASA 1000v appliances
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listCiscoAsa1000vResources.html]
        def list_cisco_asa1000v_resources(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listCiscoAsa1000vResources') 
          else
            options.merge!('command' => 'listCiscoAsa1000vResources')
          end
          request(options)
        end
      end

    end
  end
end

