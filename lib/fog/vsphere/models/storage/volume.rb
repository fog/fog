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
        attr_accessor :transport

        def destroy
          requires :vm_mo_ref, :fullpath
          Fog::Logger.deprecation("before vmdk delete with vm_moid= #{vm_mo_ref}, vmdk_path = #{fullpath}")
          response = connection.vm_delete_disk('vm_moid' => vm_mo_ref, 'vmdk_path' => fullpath)
          Fog::Logger.deprecation("after vmdk delete with vm_moid= #{vm_mo_ref}, task_state = #{response['task_state']}")
          response
        end

        #def save
        #requires :vm_mo_ref, :fullpath, :size
        #Fog::Logger.deprecation("enter save functions for :vm_mo_ref = #{vm_mo_ref}, :fullpath = #{fullpath}, :size = #{size}")
        #end

        def save
          requires :vm_mo_ref, :fullpath, :size, :transport, :unit_number
          Fog::Logger.deprecation("before vmdk creation with vm_moid= #{vm_mo_ref}, vmdk_path = #{fullpath}, disk_size = #{size}")
          response = connection.vm_create_disk(
              'vm_moid' => vm_mo_ref,
              'vmdk_path' => fullpath,
              'disk_size' => size,
              'provison_type' => mode,
              'transport'=> transport,
              'unit_number'=> unit_number
          )
          if response.has_key?('task_state') && response['task_state'] == "success"
            @scsi_key = response['scsi_key']
            @unit_number = response['unit_number']
          end
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
