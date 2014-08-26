module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists Cisco ASA 1000v appliances
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listCiscoAsa1000vResources.html]
        def list_cisco_asa1000v_resources(options={})
          options.merge!(
            'command' => 'listCiscoAsa1000vResources'  
          )
          request(options)
        end
      end

    end
  end
end

