module Fog
  module Compute
    class Cloudstack

      class Real
        # disable a Cisco Nexus VSM device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/disableCiscoNexusVSM.html]
        def disable_cisco_nexus_vsm(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'disableCiscoNexusVSM') 
          else
            options.merge!('command' => 'disableCiscoNexusVSM', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

