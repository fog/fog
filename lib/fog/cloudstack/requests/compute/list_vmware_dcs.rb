module Fog
  module Compute
    class Cloudstack

      class Real
        # Retrieves VMware DC(s) associated with a zone.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listVmwareDcs.html]
        def list_vmware_dcs(zoneid, options={})
          options.merge!(
            'command' => 'listVmwareDcs', 
            'zoneid' => zoneid  
          )
          request(options)
        end
      end

    end
  end
end

