module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a VMware datacenter to specified zone
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addVmwareDc.html]
        def add_vmware_dc(zoneid, name, vcenter, options={})
          options.merge!(
            'command' => 'addVmwareDc', 
            'zoneid' => zoneid, 
            'name' => name, 
            'vcenter' => vcenter  
          )
          request(options)
        end
      end

    end
  end
end

