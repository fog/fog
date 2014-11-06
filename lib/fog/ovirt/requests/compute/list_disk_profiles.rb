module Fog
  module Compute
    class Ovirt
      class Real
        def list_disk_profiles filter={}
          client.diskprofiles(filter)
        end
      end

      class Mock
        def list_disk_profiles(filters = {})
          xml = read_xml 'list_disk_profiles.xml'
          Nokogiri::XML(xml).xpath('/diskprofiles').map do |sd|
            OVIRT::DiskProfile::new(self, sd)
          end
        end
      end
    end
  end
end