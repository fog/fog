module Fog
  module Compute
    class Libvirt
      class Real
        def get_node_info
          node_hash = Hash.new
          node_info = client.node_get_info
          [:model, :memory, :cpus, :mhz, :nodes, :sockets, :cores, :threads].each do |param|
            node_hash[param] = node_info.send(param) rescue nil
          end
          [:type, :version, :node_free_memory, :max_vcpus].each do |param|
            node_hash[param] = client.send(param) rescue nil
          end
          node_hash[:uri] = client.uri
          xml = client.sys_info rescue nil
          [:uuid, :manufacturer, :product, :serial].each do |attr|
            node_hash[attr] = node_attr(attr, xml) rescue nil
          end if xml

          node_hash[:hostname] = client.hostname
          [node_hash]
        end

        private

        def node_attr attr, xml
          xml_element(xml, "sysinfo/system/entry[@name='#{attr}']").strip
        end
      end

      class Mock
        def get_node_info
        end
      end
    end
  end
end
