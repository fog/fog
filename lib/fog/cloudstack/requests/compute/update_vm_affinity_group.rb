module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates the affinity/anti-affinity group associations of a virtual machine. The VM has to be stopped and restarted for the new properties to take effect.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateVMAffinityGroup.html]
        def update_vm_affinity_group(id, options={})
          options.merge!(
            'command' => 'updateVMAffinityGroup', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

