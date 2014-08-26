module Fog
  module Compute
    class Cloudstack

      class Real
        # Retrieves a Cisco Nexus 1000v Virtual Switch Manager device associated with a Cluster
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listCiscoNexusVSMs.html]
        def list_cisco_nexus_vsms(options={})
          options.merge!(
            'command' => 'listCiscoNexusVSMs'  
          )
          request(options)
        end
      end

    end
  end
end

