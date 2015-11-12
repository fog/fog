module Fog
  module Compute
    class Ovirt
      class Real
        def list_volumes
          client.disks.map {|ovirt_obj| ovirt_attrs ovirt_obj}
        end
      end
      class Mock
        def list_volumes
          xml = read_xml 'disks.xml'
          Nokogiri::XML(xml).xpath('/disks/disk').map do |vol|
            ovirt_attrs OVIRT::Volume::new(self, vol)
          end
        end
      end
    end
  end
end
