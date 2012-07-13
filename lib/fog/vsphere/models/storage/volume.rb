require 'fog/core/model'

module Fog
  module Storage
    class Vsphere

      class Volume < Fog::Model

        attr_accessor :device_name
        attr_accessor :fullpath
        attr_accessor :size
        attr_accessor :scsi_key
        attr_accessor :unit_number
        attr_accessor :datastore_name
        attr_accessor :vm_mo_ref
        attr_accessor :mode

        def destroy
          requires :vm_mo_ref, :device_name
          response = connection.vm_delete_disk('vm_moid' => vm_mo_ref, 'device_name' => device_name)
          response
        end

        #def save
          #requires :vm_mo_ref, :fullpath, :size
          #Fog::Logger.deprecation("enter save functions for :vm_mo_ref = #{vm_mo_ref}, :fullpath = #{fullpath}, :size = #{size}")
        #end

        def save
          requires :vm_mo_ref, :fullpath, :size
          Fog::Logger.deprecation("before vmdk creation with vm_moid= #{vm_mo_ref}, vmdk_path = #{fullpath}, disk_size = #{size}")
          response = connection.vm_create_disk('vm_moid' => vm_mo_ref, 'vmdk_path' => fullpath, 'disk_size' => size, 'provison_type' => mode)
          Fog::Logger.deprecation("afetr vmdk creation with vm_moid= #{vm_mo_ref}, vmdk_path = #{fullpath}, disk_size = #{size}")
          response
        end

        def server
          requires :server_mo_ref
          connection.servers('mo_ref' => server_mo_ref)
        end

        def server=(new_server)
          if new_server
            #attach(new_server)
          else
            #detach
          end
        end

      end

    end
  end
end
