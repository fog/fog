module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates and automatically starts a virtual machine based on a service offering, disk offering, and template.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createAutoScaleVmGroup.html]
        def create_auto_scale_vm_group(options={})
          options.merge!(
            'command' => 'createAutoScaleVmGroup', 
            'lbruleid' => options['lbruleid'], 
            'minmembers' => options['minmembers'], 
            'scaledownpolicyids' => options['scaledownpolicyids'], 
            'scaleuppolicyids' => options['scaleuppolicyids'], 
            'vmprofileid' => options['vmprofileid'], 
            'maxmembers' => options['maxmembers']  
          )
          request(options)
        end
      end

    end
  end
end

