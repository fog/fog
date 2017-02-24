module Fog
  module Compute
    class Ovirt
      class Real
        def get_instance_type(id)
          ovirt_attrs client.instance_type(id)
        end
      end
      class Mock
        def get_instance_type(id)
          xml = read_xml 'instance_type.xml'
          ovirt_attrs OVIRT::InstanceType::new(self, Nokogiri::XML(xml).root)
        end
      end
    end
  end
end
