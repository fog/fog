require 'fog/core/model'
require 'fog/libvirt/models/compute/util'
require 'rexml/document'
require 'erb'
require 'securerandom'

module Fog
  module Compute
    class Libvirt

      class Volume < Fog::Model

        include Fog::Compute::LibvirtUtil

        identity :id , :aliases => 'key'

        attribute :pool_name

        attribute :xml

        attribute :key
        attribute :path
        attribute :name
        attribute :capacity
        attribute :allocation
        attribute :format_type

        # Can be created by passing in :xml => "<xml to create volume>"
        # A volume always belongs to a pool, :pool_name => "<name of pool>"
        #
        # @returns volume created
        def initialize(attributes={} )
          self.xml  ||= nil unless attributes[:xml]
          self.key  = nil
          self.format_type ||= "raw" unless attributes[:format_type]
          extension = self.format_type=="raw" ? "img" : self.format_type
          self.name ||= "fog-#{SecureRandom.random_number*10E14.to_i.round}.#{extension}" unless attributes[:name]
          self.capacity ||= "10G" unless attributes[:capacity]
          self.allocation ||= "1G" unless attributes[:allocation]
          super

          #We need a connection to calculate the poolname
          #This is why we do this after super
          self.pool_name  ||= default_pool_name unless attributes[:pool_name]
        end

        # Try to guess the default/first pool of no pool_name was specificed
        def default_pool_name
          default_name="default"
          default_pool=@connection.pools.all(:name => default_name)

          if default_pool.nil?
            first_pool=@connection.pools.first
            if first_pool.nil?
              raise Fog::Errors::Error.new('We could not find a pool called "default" and there was no other pool defined')
            else
              default_name=first_pool.name
            end
          end
          return default_name
        end

        # Takes a pool and either :xml or other settings
        def save
          requires :pool_name

          raise Fog::Errors::Error.new('Resaving an existing volume may create a duplicate') if key

          xml=xml_from_template if xml.nil?

          begin
            volume=nil
            pool=connection.raw.lookup_storage_pool_by_name(pool_name)
            volume=pool.create_volume_xml(xml)
            self.raw=volume
            true
          rescue
            raise Fog::Errors::Error.new("Error creating volume: #{$!}")
            false
          end

        end

        def split_size_unit(text)
          matcher=text.match(/(\d+)(.+)/)
          size=matcher[1]
          unit=matcher[2]
          return size , unit
        end

        # Create a valid xml for the volume based on the template
        def xml_from_template

          allocation_size,allocation_unit=split_size_unit(self.allocation)
          capacity_size,capacity_unit=split_size_unit(self.capacity)

          template_options={
            :name => self.name,
            :format_type => self.format_type,
            :allocation_size => allocation_size,
            :allocation_unit => allocation_unit,
            :capacity_size => capacity_size,
            :capacity_unit => capacity_unit
          }

          # We only want specific variables for ERB
          vars = ErbBinding.new(template_options)
          template_path=File.join(File.dirname(__FILE__),"templates","volume.xml.erb")
          template=File.open(template_path).readlines.join
          erb = ERB.new(template)
          vars_binding = vars.send(:get_binding)
          result=erb.result(vars_binding)
          return result
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
          xml = REXML::Document.new(self.xml)
          xml.root.elements['/volume/name'].text=name
          xml.root.elements['/volume/key'].text=name
          xml.delete_element('/volume/target/path')
          pool.create_volume_xml_from(xml.to_s,@raw)
          return connection.volumes.all(:name => name).first
        end

        #def xml_desc
          #requires :raw
          #raw.xml_desc
        #end

        private
        def raw
          @raw
        end

        def raw=(new_raw)
          @raw = new_raw

          xml = REXML::Document.new(new_raw.xml_desc)
          format_type=xml.root.elements['/volume/target/format'].attributes['type']

          raw_attributes = {
            :key => new_raw.key,
            :id => new_raw.key,
            :path => new_raw.path,
            :name => new_raw.name,
            :format_type => format_type,
            :allocation => new_raw.info.allocation,
            :capacity => new_raw.info.capacity,
            :xml => new_raw.xml_desc
          }

          merge_attributes(raw_attributes)
        end

      end

    end
  end

end
