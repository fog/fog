module Fog
  module Compute
    class Libvirt
      class Real
        def create_domain(xml)
          client.create_domain_xml(xml)
        end
      end

      class Mock
        def create_domain(xml)

        end
      end
    end
  end
end
