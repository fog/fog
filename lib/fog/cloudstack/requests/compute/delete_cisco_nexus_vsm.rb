module Fog
  module Compute
    class Cloudstack

      class Real
        #  delete a Cisco Nexus VSM device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteCiscoNexusVSM.html]
        def delete_cisco_nexus_vsm(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteCiscoNexusVSM') 
          else
            options.merge!('command' => 'deleteCiscoNexusVSM', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

