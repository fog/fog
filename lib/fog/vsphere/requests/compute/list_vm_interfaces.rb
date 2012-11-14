module Fog
  module Compute
    class Vsphere
      class Real
  # => VirtualE1000(
  #addressType: "assigned",
  #backing: VirtualEthernetCardNetworkBackingInfo(
  #  deviceName: "VM Network",
  #  dynamicProperty: [],
  #  network: Network("network-163"),
  #  useAutoDetect: false
  #),
  #connectable: VirtualDeviceConnectInfo(
  #  allowGuestControl: true,
  #  connected: true,
  #  dynamicProperty: [],
  #  startConnected: true,
  #  status: "ok"
  #),
  #controllerKey: 100,
  #deviceInfo: Description(
  #  dynamicProperty: [],
  #  label: "Network adapter 1",
  #  summary: "VM Network"
  #),
  #dynamicProperty: [],
  #key: 4000,
  #macAddress: "00:50:56:a9:00:28",
  #unitNumber: 7,
  #
        def list_vm_interfaces(vm_id)
          get_vm_ref(vm_id).config.hardware.device.grep(RbVmomi::VIM::VirtualEthernetCard).map do |nic|
            {
              :name    => nic.deviceInfo.label,
              :mac     => nic.macAddress,
              :network => nic.backing.network.name,
              :status  => nic.connectable.status,
              :summary => nic.deviceInfo.summary,
              :type    => nic.class,
            }
          end

        end

      end
      class Mock
        def list_vm_interfaces(vm_id)
        end
      end
    end
  end
end
