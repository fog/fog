require 'fog/core/model'

module Fog
  module Compute
    class Linode
      class Disk < Fog::Model
        identity :id
        attribute :name
        attribute :type

        def save
          requires :server
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          @type, @image, @stack_script, @name, @password, @size =
            attributes.values_at :type, :image, :stack_script, :name, :password, :size
          create_disk
        end

        def destroy
          requires :identity, :server
          service.linode_disk_delete server.id, id
        end

        def server
          @server
        end

        private
        def server=(server)
          @server = server
        end

        def create_disk
          case
          when @image && @stack_script then create_disk_from_stack_script
          when @image then create_disk_from_image
          when @type then create_disk_type
          else raise 'disk cannot be created'
          end
        end

        def create_disk_type
          self.id = service.linode_disk_create(server.id, "#{@name}_#{@type}", @type, @size).body['DATA']['DiskID']
          reload
        end

        def create_disk_from_image
          disk = service.linode_disk_createfromdistribution server.id, @image.id, "#{@name}_main", @size, @password
          self.id = disk.body['DATA']['DiskID']
          reload
        end

        def create_disk_from_stack_script
          disk = service.linode_disk_createfromstackscript(server.id, @stack_script.id, @image.id,
                                                              "#{@name}_main", @size, @password, @stack_script.options)
          self.id = disk.body['DATA']['DiskID']
          reload
        end
      end
    end
  end
end
