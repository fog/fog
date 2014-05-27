module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a VMware datacenter to specified zone
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addVmwareDc.html]
        def add_vmware_dc(options={})
          options.merge!(
            'command' => 'addVmwareDc', 
            'name' => options['name'], 
            'vcenter' => options['vcenter'], 
            'zoneid' => options['zoneid']  
          )
          request(options)
        end
      end

    end
  end
end

