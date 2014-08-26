module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates and automatically starts a virtual machine based on a service offering, disk offering, and template.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createAutoScaleVmGroup.html]
        def create_auto_scale_vm_group(options={})
          request(options)
        end


        def create_auto_scale_vm_group(minmembers, scaleuppolicyids, scaledownpolicyids, maxmembers, vmprofileid, lbruleid, options={})
          options.merge!(
            'command' => 'createAutoScaleVmGroup', 
            'minmembers' => minmembers, 
            'scaleuppolicyids' => scaleuppolicyids, 
            'scaledownpolicyids' => scaledownpolicyids, 
            'maxmembers' => maxmembers, 
            'vmprofileid' => vmprofileid, 
            'lbruleid' => lbruleid  
          )
          request(options)
        end
      end

    end
  end
end

