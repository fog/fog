module Fog
  module Compute
    class Azure
      class Real
        def list_virtual_machines
          @vm_svc.list_virtual_machines
        end
      end

      class Mock
        def list_virtual_machines
          vm = ::Azure::VirtualMachineManagement::VirtualMachine.new
          vm.cloud_service_name = "cool-vm"
          vm.status = "ReadyRole"
          vm.ipaddress = "123.45.67.89"
          vm.vm_name = "cool-vm"
          vm.udp_endpoints = []
          vm.hostname = "cool-vm"
          vm.deployment_name = "cool-vm"
          vm.deployment_status = "Running"
          vm.tcp_endpoints = [
            {"Name"=>"http", "Vip"=>"123.45.67.89", "PublicPort"=>"80", "LocalPort"=>"80"},
            {"Name"=>"SSH", "Vip"=>"123.45.67.89", "PublicPort"=>"22", "LocalPort"=>"22"}
          ]
          vm.role_size = "Medium"
          vm.os_type = "Linux"
          vm.disk_name = "cool-vm-cool-vm-0-20130207005053"
          vm.virtual_network_name = ""
          vm.image = nil
          #vm.virtual_network = nil
          list = [vm]
        end
      end
    end
  end
end
