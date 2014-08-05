module Fog
  module Compute
    class Cloudstack

      class Real
        # Remove a VMware datacenter from a zone.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/removeVmwareDc.html]
        def remove_vmware_dc(zoneid, options={})
          options.merge!(
            'command' => 'removeVmwareDc', 
            'zoneid' => zoneid  
          )
          request(options)
        end
      end

    end
  end
end

