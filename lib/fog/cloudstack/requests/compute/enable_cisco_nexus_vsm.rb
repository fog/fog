module Fog
  module Compute
    class Cloudstack

      class Real
        # Enable a Cisco Nexus VSM device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/enableCiscoNexusVSM.html]
        def enable_cisco_nexus_vsm(id, options={})
          options.merge!(
            'command' => 'enableCiscoNexusVSM', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

