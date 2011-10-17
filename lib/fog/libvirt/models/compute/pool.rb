require 'fog/core/model'

module Fog
  module Compute
    class Libvirt

      class Pool < Fog::Model

        identity :uuid

        # These attributes are only used for creation
        attribute :xml
        attribute :create_persistent
        attribute :create_auto_build

        # Can be created by passing in XML
        def initialize(attributes={} )
          self.xml  ||= nil unless attributes[:xml]
          self.create_persistent  ||= true unless attributes[:create_persistent]
          self.create_auto_build ||= true unless attributes[:create_auto_build]
          super
        end

        def save
          requires :xml
          unless xml.nil?
            pool=nil
            if self.create_persistent
              pool=connection.raw.define_storage_pool_xml(xml)
            else
              pool=connection.raw.create_storage_pool_xml(xml)
            end
            self.raw=pool
            true
          else
            raise Fog::Errors::Error.new('Creating a new pool requires proper xml')
            false
          end
        end


        # Start the pool = make it active
        # Performs a libvirt create (= start)
        def start
          requires :raw

          @raw.create
        end

        # Stop the pool = make it non-active
        # Performs a libvirt destroy (= stop)
        def stop
          requires :raw

          @raw.destroy
        end

        # Shuts down the pool
        def shutdown
          requires :raw

          @raw.destroy
          true
        end

        # Build this storage pool
        def build
          requires :raw

          @raw.build unless @raw.nil?
        end

        # Destroys the storage pool
        def destroy( destroy_options={})
          requires :raw

          # Shutdown pool if active
          @raw.destroy if @raw.active?

          # Delete corresponding data in this pool
          # @raw.delete

          # If this is a persistent domain we need to undefine it
          @raw.undefine if @raw.persistent?

        end

        # Set autostart value of the storage pool (true|false)
        def auto_start=(flag)
          requires :raw

          @raw.auto_start(flag)
        end

        # Is the pool active or not?
        def active?
          requires :raw

          @raw.active?
        end

        # Will the pool autostart or not?
        def auto_start?
          requires :raw

          @raw.autostart?
        end

        # Is the pool persistent or not?
        def persistent?
          requires :raw
          @raw.persistent?
        end

        # Returns the xml description of the current pool
        def xml_desc
          requires :raw

          @raw.xml_desc unless @raw.nil?
        end


        # Retrieves the name of the pool
        def name
          requires :raw
          @raw.name
        end

        # Retrieves the uuid of the pool
        def uuid
          requires :raw
          @raw.uuid
        end

        # Retrieves the allocated disk space of the pool
        def allocation
          requires :raw
          @raw.info.allocation
        end

        # Retrieves the capacity of disk space of the pool
        def capacity
          requires :raw
          @raw.info.capacity
        end

        # Retrieves the number of volumes available in this pool
        def num_of_volumes
          requires :raw
          @raw.num_of_volumes
        end

        def state
          requires :raw

          #INACTIVE = INT2NUM(VIR_STORAGE_POOL_INACTIVE)     virStoragePoolState
          #BUILDING = INT2NUM(VIR_STORAGE_POOL_BUILDING)
          #RUNNING  = INT2NUM(VIR_STORAGE_POOL_RUNNING)
          #DEGRADED = INT2NUM(VIR_STORAGE_POOL_DEGRADED)
          #INACCESSIBLE = INT2NUM(VIR_STORAGE_POOL_INACCESSIBLE)
          states=[:inactive, :building,:running,:degrated,:inaccessible]

          return states[@raw.info.state]

        end

        # Retrieves the volumes of this pool
        def volumes

          volumes=Array.new
          @raw.list_volumes.each do |volume|
            fog_volume=connection.volumes.all(:name => volume).first
            volumes << fog_volume
          end
          return volumes
        end

        private

        def raw
          @raw
        end

        def raw=(new_raw)
          @raw = new_raw

          raw_attributes = {
            :uuid => new_raw.uuid,

          }

          merge_attributes(raw_attributes)
        end

      end

    end
  end

end
