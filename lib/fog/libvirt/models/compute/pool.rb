require 'fog/core/model'

module Fog
  module Compute
    class Libvirt

      class Pool < Fog::Model
        attr_reader :xml

        identity :uuid

        attribute :persistent
        attribute :autostart
        attribute :active
        attribute :name
        attribute :allocation
        attribute :capacity
        attribute :num_of_volumes
        attribute :state

        def initialize(attributes={} )
          # Can be created by passing in XML
          @xml = attributes.delete(:xml)
          super(attributes)
        end

        def save
          raise Fog::Errors::Error.new('Creating a new pool requires proper xml') unless xml
          self.uuid = (persistent ? connection.define_pool(xml) : connection.create_pool(xml)).uuid
          reload
        end

        # Start the pool = make it active
        # Performs a libvirt create (= start)
        def start
          connection.pool_action uuid, :create
        end

        # Stop the pool = make it non-active
        # Performs a libvirt destroy (= stop)
        def stop
          connection.pool_action uuid, :destroy
        end

        # Shuts down the pool
        def shutdown
          stop
        end

        # Build this storage pool
        def build
          connection.pool_action uuid, :build
        end

        # Destroys the storage pool
        def destroy
          # Shutdown pool if active
          connection.pool_action uuid, :destroy if active?
          # If this is a persistent domain we need to undefine it
          connection.pool_action uuid, :undefine if persistent?
        end

        # Is the pool active or not?
        def active?
          active
        end

        # Will the pool autostart or not?
        def auto_start?
          autostart
        end

        # Is the pool persistent or not?
        def persistent?
          persistent
        end

        # Retrieves the volumes of this pool
        def volumes
          connection.list_pool_volumes uuid
        end

      end

    end
  end

end
