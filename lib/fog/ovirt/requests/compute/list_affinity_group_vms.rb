module Fog
  module Compute
    class Ovirt
      class Real
        def list_affinity_group_vms(id)
          client.affinity_group_vms(id).collect {|vm| servers.get(vm.id)}
        end
      end

      class Mock
        def list_affinity_group_vms(id)
          vms = []
          Nokogiri::XML(read_xml('affinitygroup_vms.xml')).xpath('/vms/vm/@id').each do |attr|
            vms << ovirt_attrs(OVIRT::VM::new(self, Nokogiri::XML(read_xml('vms.xml')).xpath("/vms/vm[@id='%s']" % attr.value).first))
          end
          vms
        end
      end
    end
  end
end
