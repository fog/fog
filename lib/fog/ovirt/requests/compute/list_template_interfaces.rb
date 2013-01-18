module Fog
  module Compute
    class Ovirt
      class Real
        def list_template_interfaces(vm_id)
          client.template_interfaces(vm_id).map {|ovirt_obj| ovirt_attrs ovirt_obj}
        end

      end
      class Mock
        def list_template_interfaces(vm_id)
          xml = read_xml 'nics.xml'
          Nokogiri::XML(xml).xpath('/nics/nic').collect do |nic|
            ovirt_attrs OVIRT::Interface::new(self, nic)
          end
        end
      end
    end
  end
end
