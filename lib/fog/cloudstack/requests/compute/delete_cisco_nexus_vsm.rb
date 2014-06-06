module Fog
  module Compute
    class Cloudstack

      class Real
        #  delete a Cisco Nexus VSM device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteCiscoNexusVSM.html]
        def delete_cisco_nexus_vsm(id, options={})
          options.merge!(
            'command' => 'deleteCiscoNexusVSM', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

