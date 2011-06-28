require 'fog/core/model'

module Fog
  module Compute
    class Libvirt

      class Pool < Fog::Model

        identity :id
        
        attribute :name
        attribute :uuid        
        attribute :xml

        attr_reader :allocation
        attr_reader :available
        attr_reader :xml_desc
        attr_reader :num_of_volumes
        attr_reader :state
        
        # There are two options to initialize a new Pool
        # 1. provide :xml as an argument
        # 2. provide :name, :path
        def initialize(attributes={})
#          unless attributes.has_key?(:xml)
#            name = attributes[:name] || raise("Must provide a pool name")
#            path = attributes[:path] || "/var/lib/libvirt/images"
#          else
#            @xml = attributes[:xml]
#          end            
          super          
          
        end
        
        def save
          unless @xml.nil?
            #connection.
          end
        end
        
        def destroy
          requires :raw
          
          # Shutdown pool if active
          if raw.active?
            raw.destroy
          end
          # Delete corresponding data in this pool
          raw.delete
          
          true
        end
        
        def shutdown
          requires :raw
          raw.destroy
          true
        end
        
        private

        def raw
          @raw
        end

        def raw=(new_raw)
          @raw = new_raw

          raw_attributes = { 
            :id => new_raw.uuid,
            :uuid => new_raw.uuid,
            :name => new_raw.name,
            :xml_desc => new_raw.xml_desc,
            :num_of_volumes => new_raw.num_of_volumes,
            :allocation => new_raw.info.allocation, 
            :available => new_raw.info.available, 
            :capacity => new_raw.info.capacity,
            :state => new_raw.info.state,
          }
          
          # State
          #INACTIVE	=	INT2NUM(VIR_STORAGE_POOL_INACTIVE)	 	 virStoragePoolState
          #BUILDING	=	INT2NUM(VIR_STORAGE_POOL_BUILDING)
          #RUNNING	=	INT2NUM(VIR_STORAGE_POOL_RUNNING)
          #DEGRADED	=	INT2NUM(VIR_STORAGE_POOL_DEGRADED)
          #INACCESSIBLE	=	INT2NUM(VIR_STORAGE_POOL_INACCESSIBLE)
          
          merge_attributes(raw_attributes)
        end
        
      end

    end
  end

end
