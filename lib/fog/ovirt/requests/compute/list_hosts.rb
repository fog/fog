module Fog
  module Compute
    class Ovirt
      class Real
        def list_hosts(filters = {})
          client.hosts(filters).map {|ovirt_obj| ovirt_attrs ovirt_obj}
        end

      end
      class Mock
        def list_hosts(filters = {})
          xml = read_xml 'hosts.xml'
          Nokogiri::XML(xml).xpath('/hosts/host').collect do |cl|
            ovirt_attrs OVIRT::Host::new(self, cl)
          end
        end
      end
    end
  end
end
