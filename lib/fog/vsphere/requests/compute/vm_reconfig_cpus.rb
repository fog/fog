module Fog
  module Compute
    class Vsphere
      class Real
        def vm_reconfig_cpus(options = {})
          raise ArgumentError, "cpus is a required parameter" unless options.key? 'cpus'
          raise ArgumentError, "instance_uuid is a required parameter" unless options.key? 'instance_uuid'
          hardware_spec={'numCPUs' => options['cpus'], 'numCoresPerSocket' => options['corespersocket']}
          vm_reconfig_hardware('instance_uuid' => options['instance_uuid'], 'hardware_spec' => hardware_spec )
        end
      end

      class Mock
        def vm_reconfig_cpus(options = {})
          raise ArgumentError, "cpus is a required parameter" unless options.key? 'cpus'
          raise ArgumentError, "instance_uuid is a required parameter" unless options.key? 'instance_uuid'
          hardware_spec={'numCPUs' => options['cpus'], 'numCoresPerSocket' => options['corespersocket']}
          vm_reconfig_hardware('instance_uuid' => options['instance_uuid'], 'hardware_spec' => hardware_spec )
        end
      end
    end
  end
end
