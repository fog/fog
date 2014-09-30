module Fog
  module Compute
    class Cloudstack

      class Real
        # Retrieves a Cisco Nexus 1000v Virtual Switch Manager device associated with a Cluster
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listCiscoNexusVSMs.html]
        def list_cisco_nexus_vsms(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listCiscoNexusVSMs') 
          else
            options.merge!('command' => 'listCiscoNexusVSMs')
          end
          request(options)
        end
      end

    end
  end
end

