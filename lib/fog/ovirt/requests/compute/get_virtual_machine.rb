module Fog
  module Compute
    class Ovirt
      class Real
        def get_virtual_machine(id)
          ovirt_attrs client.vm(id)
        end

      end
      class Mock
        def get_virtual_machine(id)
          xml = read_xml 'vm.xml'
          ovirt_attrs OVIRT::VM::new(self, Nokogiri::XML(xml).root)
        end
      end
    end
  end
end
