require 'fog/core/model'
require 'fog/libvirt/models/compute/util/util'

module Fog
  module Compute
    class Libvirt

      class Volume < Fog::Model

        attr_reader :xml
        include Fog::Compute::LibvirtUtil

        identity :id, :aliases => 'key'

        attribute :pool_name
        attribute :key
        attribute :name
        attribute :path
        attribute :capacity
        attribute :allocation
        attribute :format_type
        attribute :backing_volume

        # Can be created by passing in :xml => "<xml to create volume>"
        # A volume always belongs to a pool, :pool_name => "<name of pool>"
        #
        def initialize(attributes={ })
          @xml = attributes.delete(:xml)
          super(defaults.merge(attributes))

          # We need a connection to calculate the pool_name
          # This is why we do this after super
          self.pool_name ||= default_pool_name
        end

        # Takes a pool and either :xml or other settings
        def save
          requires :pool_name

          raise Fog::Errors::Error.new('Reserving an existing volume may create a duplicate') if key
          @xml ||= to_xml
          self.path = service.create_volume(pool_name, xml).path
        end

        # Destroy a volume
        def destroy
          service.volume_action key, :delete
        end

        # Wipes a volume , zeroes disk
        def wipe
          service.volume_action key, :wipe
        end

        # Clones this volume to the name provided
        def clone(name)
          new_volume      = self.dup
          new_volume.key  = nil
          new_volume.name = name
          new_volume.save

          new_volume.reload
        end

        def clone_volume(new_name)
          requires :pool_name

          new_volume      = self.dup
          new_volume.key  = nil
          new_volume.name = new_name
          new_volume.path = service.clone_volume(pool_name, new_volume.to_xml, self.name).path

          new_volume.reload
        end

        private

        def image_suffix
          return "img" if format_type == "raw"
          format_type
        end

        def randominzed_name
          "#{super}.#{image_suffix}"
        end

        # Try to guess the default/first pool of no pool_name was specified
        def default_pool_name
          name = "default"
          return name unless (service.pools.all(:name => name)).empty?

          # we default to the first pool we find.
          first_pool = service.pools.first

          raise Fog::Errors::Error.new('No storage pools are defined') unless first_pool
          first_pool.name
        end

        def defaults
          {
            :persistent  => true,
            :format_type => "raw",
            :name        => randomized_name,
            :capacity    => "10G",
            :allocation  => "1G",
          }
        end

        def split_size_unit(text)
          if text.kind_of? Integer
            # if text is an integer, match will fail
            size    = text
            unit    = 'G'
          else
            matcher = text.match(/(\d+)(.+)/)
            size    = matcher[1]
            unit    = matcher[2]
          end
          [size, unit]
        end
      end

    end
  end

end
