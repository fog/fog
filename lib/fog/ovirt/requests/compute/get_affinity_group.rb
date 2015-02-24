module Fog
  module Compute
    class Ovirt
      class Real
        def get_affinity_group(id)
          ovirt_attrs client.affinity_group(id)
        end
      end

      class Mock
        def get_affinity_group(id)
          xml = read_xml('affinitygroup.xml')
          ovirt_attrs OVIRT::AffinityGroup::new(self, Nokogiri::XML(xml).root)
        end
      end
    end
  end
end
