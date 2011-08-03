require 'fog/core/model'
require 'fog/compute/models/libvirt/util'
require 'rexml/document'
require 'erb'
require 'securerandom'

module Fog
  module Compute
    class Libvirt

      class Volume < Fog::Model

        include Fog::Compute::LibvirtUtil

        identity :key

        attribute :poolname
        
        attribute :xml
        attribute :template_options
        
#        attribute :key
        attribute :path
        attribute :name
        attribute :capacity
        attribute :allocation
        attribute :type

        # Can be created by passing in :xml => "<xml to create volume>" 
        # A volume always belongs to a pool, :poolname => "<name of pool>"
        #
        # @returns volume created
        def initialize(attributes={} )
          self.xml  ||= nil unless attributes[:xml]
          
          super
          
          # Try to guess the default/first pool of no poolname was specificed
          default_pool_name="default"
          default_pool=connection.pools.all(:name => "default")
          if default_pool.nil?
            first_pool=connection.pools.first
            if first_pool.nil?
              raise Fog::Errors::Error.new('We could not find a pool called "default" and there was no other pool defined')
            else  
               default_pool_name=first_pool.name
            end
            
          end
          
          self.poolname  ||= default_pool_name unless attributes[:poolname]
          
        end

        # Takes a pool and either uses :xml  or :template_options->xml to create the volume
        def save
#          requires :xml
#          requires :poolname

          if poolname
            # :disk_type => "raw",
            # :disk_extension => "img",
            # :disk_size => "10000",
            # We have a template, let's generate some xml for it                        
            if !template_options.nil?

              template_defaults={ 
                :type => "raw",
                :extension => "img",
                :size => 10,
                :allocate_unit => "G",
                :size_unit => "G",
                :allocate => 1,
              }
              template_options2=template_defaults.merge(template_options)
              template_options={ :name => "fog-#{SecureRandom.random_number*10E14.to_i.round}.#{template_options2[:extension]}"}.merge(template_options2)

              validate_template_options(template_options)

              xml=xml_from_template(template_options)

            end

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

        end
        
          def validate_template_options(template_options)
            # Here we can validate the template_options
          end

          def xml_from_template(template_options)                     

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
            xml = REXML::Document.new(xml_desc)
            xml.root.elements['/volume/name'].text=name
            xml.root.elements['/volume/key'].text=name
            xml.delete_element('/volume/target/path')
            pool.create_volume_xml_from(xml.to_s,@raw)
            return connection.volumes.all(:name => name)
          end

          def xml_desc
            requires :raw
            raw.xml_desc
          end

          private
          def raw
            @raw
          end

          def raw=(new_raw)
            @raw = new_raw

            raw_attributes = { 
              :key => new_raw.key,
              :path => new_raw.path,
              :name => new_raw.name,
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
