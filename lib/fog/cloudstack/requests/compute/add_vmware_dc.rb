module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a VMware datacenter to specified zone
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addVmwareDc.html]
        def add_vmware_dc(options={})
          request(options)
        end


        def add_vmware_dc(zoneid, vcenter, name, options={})
          options.merge!(
            'command' => 'addVmwareDc', 
            'zoneid' => zoneid, 
            'vcenter' => vcenter, 
            'name' => name  
          )
          request(options)
        end
      end

    end
  end
end

