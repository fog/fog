module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates the affinity/anti-affinity group associations of a virtual machine. The VM has to be stopped and restarted for the new properties to take effect.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateVMAffinityGroup.html]
        def update_vm_affinity_group(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateVMAffinityGroup') 
          else
            options.merge!('command' => 'updateVMAffinityGroup', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

