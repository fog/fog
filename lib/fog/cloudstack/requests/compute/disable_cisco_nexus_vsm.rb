module Fog
  module Compute
    class Cloudstack

      class Real
        # disable a Cisco Nexus VSM device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/disableCiscoNexusVSM.html]
        def disable_cisco_nexus_vsm(id, options={})
          options.merge!(
            'command' => 'disableCiscoNexusVSM', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

