module Fog
  module Compute
    class Vsphere
      class Real

        def find_template_by_instance_uuid(instance_uuid)
          vm = list_virtual_machines.detect(lambda { raise Fog::Vsphere::Errors::NotFound }) do |vm|
            vm.config.instanceUuid == instance_uuid
          end
          unless vm.config.template
            raise Fog::Vsphere::Errors::NotFound, "VM with Instance UUID #{instance_uuid} is not a template."
          end
          vm
        end

      end

      class Mock

        def find_template_by_instance_uuid(instance_uuid)
          Fog::Mock.not_implmented
        end

      end
    end
  end
end
