module Fog
  module Compute
    class Ovirt
      class Real
        def list_vm_interfaces(vm_id)
          client.vm_interfaces(vm_id).map {|ovirt_obj| ovirt_attrs ovirt_obj}
        end
      end
      class Mock
        def list_vm_interfaces(vm_id)
          xml = read_xml 'nics.xml'
          Nokogiri::XML(xml).xpath('/nics/nic').map do |nic|
            ovirt_attrs OVIRT::Interface::new(self, nic)
          end
        end
      end
    end
  end
end
