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
          vm.cloud_service_name = 'cool-vm'
          vm.status = 'ReadyRole'
          vm.ipaddress = '123.45.67.89'
          vm.vm_name = 'cool-vm'
          vm.udp_endpoints = []
          vm.hostname = 'cool-vm'
          vm.deployment_name = 'cool-vm'
          vm.deployment_status = 'Running'
          vm.tcp_endpoints = [{"Name"=>"open-port",
          "Vip"=>"123.45.67.89", "PublicPort"=>"1234",
          "LocalPort"=>"1234"}, {"Name"=>"another-port",
          "Vip"=>"123.45.67.89", "PublicPort"=>"5678",
          "LocalPort"=>"5678"}, {"Name"=>"http",
          "Vip"=>"123.45.67.89", "PublicPort"=>"80",
          "LocalPort"=>"80"}, {"Name"=>"SSH", "Vip"=>"123.45.67.89",
          "PublicPort"=>"22", "LocalPort"=>"22"}]
          vm.role_size = 'Medium'
          vm.storage_account_name = 'stg-accnt'
          vm.os_type = 'Linux'
          vm.disk_name = 'cool-vm-cool-vm-0-20130207005053'
          vm.virtual_network_name = ''
          vm.password = nil
          vm.vm_user = nil
          vm.image = nil
          vm.virtual_network = nil
          list = [vm]
        end

      end

    end
  end
end
