module Fog
  module Compute
    class Ovirt
      class Real
        def list_virtual_machines(filters = {})
          client.vms(filters).map {|ovirt_obj| ovirt_attrs ovirt_obj}
        end

      end
      class Mock
        def list_virtual_machines(filters = {})
          xml = read_xml 'vms.xml'
          Nokogiri::XML(xml).xpath('/vms/vm').collect do |vm|
            ovirt_attrs OVIRT::VM::new(self, vm)
          end
        end
      end
    end
  end
end
