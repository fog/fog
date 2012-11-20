module Fog
  module Compute
    class Ovirt
      class Real
        def get_host(id)
          ovirt_attrs client.host(id)
        end

      end
      class Mock
        def get_host(id)
          xml = read_xml('host.xml')
          ovirt_attrs OVIRT::Host::new(self, Nokogiri::XML(xml).root)
        end
      end
    end
  end
end
