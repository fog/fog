require 'fog/core/model'

module Fog
  module Compute
    class Libvirt

      class Volume < Fog::Model

        identity :id

        attribute :poolname
        attribute :xml
        
        # Can be created by passing in :xml => "<xml to create volume>" 
        # A volume always belongs to a pool, :pool => "<name of pool>"
        #
        # @returns volume created
        def initialize(attributes={} )
          self.xml  ||= nil unless attributes[:xml]
          self.poolname  ||= nil unless attributes[:poolname]
          super
        end

        # Takes a pool and xml to create the volume
        def save
          requires :xml
          requires :poolname
          
          unless xml.nil?
            volume=nil
            unless poolname.nil?
              pool=connection.lookup_storage_pool_by_name(poolname)
              volume=pool.create_volume_xml(xml)
              self.raw=volume
              true
            else
              raise Fog::Errors::Error.new('Creating a new volume requires a pool name or uuid')
              false
            end
          else
            raise Fog::Errors::Error.new('Creating a new volume requires non empty xml')
            false
          end
        end


        # Destroy a volume
        def destroy
          requires :raw
          raw.delete
          true
        end

        # Wipes a volume , zeroes disk
        def wipe
          requires :raw
          raw.wipe
          true
        end
        
        # Clones this volume to the name provided     
        def clone(name)
          pool=@raw.pool
          xml = REXML::Document.new(xml_desc)
          xml.root.elements['/volume/name'].text=name
          xml.root.elements['/volume/key'].text=name
          xml.delete_element('/volume/target/path')
          pool.create_volume_xml_from(xml.to_s,@raw)
          return connection.volumes.get(:name => name)
        end
                
        def key
          requires :raw
          raw.key
        end
        
        def path
          requires :raw
          raw.path
        end
        
        def name
          requires :raw
          raw.name
        end
        
        def xml_desc
          requires :raw
          raw.xml_desc
        end
        
        
        def allocation
          requires :raw
          raw.info.allocation
        end
        
        def capacity
          requires :raw
          raw.info.capacity
        end
        
        def type
          requires :raw
          raw.info.type
        end
        
        
        private
        def raw
          @raw
        end

        def raw=(new_raw)
          @raw = new_raw

          raw_attributes = { 
            :id => new_raw.key,
          }
          
          merge_attributes(raw_attributes)
        end
        
      end

    end
  end

end
