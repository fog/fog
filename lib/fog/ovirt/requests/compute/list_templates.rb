module Fog
  module Compute
    class Ovirt
      class Real
        def list_templates(filters = {})
          client.templates(filters).map {|ovirt_obj| ovirt_attrs ovirt_obj}
        end

      end
      class Mock
        def list_templates(filters = {})
          xml = read_xml 'templates.xml'
          Nokogiri::XML(xml).xpath('/templates/template').collect do |t|
            ovirt_attrs OVIRT::Template::new(self, t)
          end
        end
      end
    end
  end
end
