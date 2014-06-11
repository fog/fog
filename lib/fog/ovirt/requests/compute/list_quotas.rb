module Fog
  module Compute
    class Ovirt
      class Real
        def list_quotas(filters = {})
          client.quotas(filters).map {|ovirt_obj| ovirt_attrs ovirt_obj}
        end
      end
      class Mock
        def list_quotas(filters = {})
          xml = read_xml 'quotas.xml'
          Nokogiri::XML(xml).xpath('/quotas/quota').map do |q|
            ovirt_attrs OVIRT::Quotas::new(self, q)
          end
        end
      end
    end
  end
end
