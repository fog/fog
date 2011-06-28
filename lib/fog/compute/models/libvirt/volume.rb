require 'fog/core/model'

module Fog
  module Compute
    class Libvirt

      class Volume < Fog::Model

        identity :id
        
        attribute :key
        attribute :path
        attribute :name
        attribute :type
        attribute :allocation
        attribute :capacity
        attribute :xml_desc

        def destroy
          requires :raw
          raw.delete
          true
        end

        def wipe
          requires :raw
          raw.wipe
          true
        end
                
        def clone(name)
          pool=@raw.pool
          xml = REXML::Document.new(xml_desc)
          xml.root.elements['/volume/name'].text=name
          xml.root.elements['/volume/key'].text=name
          xml.delete_element('/volume/target/path')
          puts "cloning this might take a while"
          pool.create_volume_xml_from(xml.to_s,@raw)
          return connection.volumes.get(name)
        end
        
        private

        def raw
          @raw
        end

        def raw=(new_raw)
          @raw = new_raw

          raw_attributes = { 
            :id => new_raw.key,
            :key => new_raw.key,
            :path => new_raw.path ,
            :name => new_raw.name,
            :xml_desc => new_raw.xml_desc,
            :allocation => new_raw.info.allocation,
            :capacity => new_raw.info.capacity,
            :type => new_raw.info.type
          }
          
          merge_attributes(raw_attributes)
        end
        
      end

    end
  end

end
