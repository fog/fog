module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates and automatically starts a virtual machine based on a service offering, disk offering, and template.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createAutoScaleVmGroup.html]
        def create_auto_scale_vm_group(lbruleid, vmprofileid, scaleuppolicyids, minmembers, scaledownpolicyids, maxmembers, options={})
          options.merge!(
            'command' => 'createAutoScaleVmGroup', 
            'lbruleid' => lbruleid, 
            'vmprofileid' => vmprofileid, 
            'scaleuppolicyids' => scaleuppolicyids, 
            'minmembers' => minmembers, 
            'scaledownpolicyids' => scaledownpolicyids, 
            'maxmembers' => maxmembers  
          )
          request(options)
        end
      end

    end
  end
end

