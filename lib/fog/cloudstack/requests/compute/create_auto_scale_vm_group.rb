module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates and automatically starts a virtual machine based on a service offering, disk offering, and template.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createAutoScaleVmGroup.html]
        def create_auto_scale_vm_group(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createAutoScaleVmGroup') 
          else
            options.merge!('command' => 'createAutoScaleVmGroup', 
            'minmembers' => args[0], 
            'scaleuppolicyids' => args[1], 
            'scaledownpolicyids' => args[2], 
            'maxmembers' => args[3], 
            'vmprofileid' => args[4], 
            'lbruleid' => args[5])
          end
          request(options)
        end
      end

    end
  end
end

