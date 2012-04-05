module Fog
  module Compute
    class Libvirt
      class Real
        def define_domain(xml)
          client.define_domain_xml(xml)
        end
      end

      class Mock
        def define_domain(xml)

        end
      end
    end
  end
end
