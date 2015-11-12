module Fog
  module Compute
    class Ovirt
      class Real
        def list_affinity_groups(filters = {})
          client.affinity_groups(filters).map {|ovirt_obj| ovirt_attrs ovirt_obj}
        end
      end

      class Mock
        def list_affinity_groups(filters = {})
          xml = read_xml('affinitygroups.xml')
          Nokogiri::XML(xml).xpath('/affinity_groups/affinity_group').map do |ag|
            ovirt_attrs OVIRT::AffinityGroup::new(self, ag)
          end
        end
      end
    end
  end
end
