module Fog
  module Compute
    class Ovirt
      class Real

        def datacenters filter={}
          client.datacenters(filter).map {|ovirt_obj| ovirt_attrs ovirt_obj}
        end

      end

        class Mock
        def datacenters(filters = {})
          xml = read_xml 'data_centers.xml'
          Nokogiri::XML(xml).xpath('/data_centers/data_center').collect do |dc|
            ovirt_attrs OVIRT::DataCenter::new(self, dc)
          end
        end
      end
    end
  end
end
