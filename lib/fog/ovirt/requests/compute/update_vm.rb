module Fog
  module Compute
    class Ovirt

      class Real
        def update_vm(attrs)
          client.update_vm(attrs)
        end
      end

      class Mock
        def update_vm(attrs)
          xml = read_xml('vm.xml')
          OVIRT::VM::new(self, Nokogiri::XML(xml).root)
        end

      end
    end
  end
end
