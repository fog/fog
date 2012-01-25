module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates and automatically starts a virtual machine based on a service offering, disk offering, and template.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/deployVirtualMachine.html]
        def deploy_virtual_machine(options={})
          options.merge!(
            'command' => 'deployVirtualMachine'
          )

          if ( securitygroupids = options.delete('securitygroupids') ).is_a?(Array)
            options.merge!('securitygroupids' => securitygroupids.join(','))
          end
          
          if ( securitygroupnames = options.delete('securitygroupnames') ).is_a?(Array)
            options.merge!('securitygroupnames' => securitygroupnames.join(','))
          end
          
          if ( networkids = options.delete('networkids') ).is_a?(Array)
            options.merge!('networkids' => networkids.join(','))
          end
          
          
          request(options)
        end

      end
    end
  end
end
