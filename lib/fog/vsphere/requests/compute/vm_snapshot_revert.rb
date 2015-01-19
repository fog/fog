module Fog
  module Compute
    class Vsphere
      class Real

        def vm_snapshot_revert(options = {})
          options = { 'force' => false }.merge(options)
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'
          raise ArgumentError, "name is a required parameter" unless options.has_key? 'name'

          options = { 'force' => false }.merge(options)
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'

          search_filter = { :uuid => options['instance_uuid'], 'vmSearch' => true, 'instanceUuid' => true }
          vm_mob_ref = @connection.searchIndex.FindAllByUuid(search_filter).first
          raise "vm_snapshot_revert is not implemented"

        end

      end

      class Mock

        def vm_snapshot(options = {})
          raise ArgumentError, "instance_uuid is a required parameter" unless options.has_key? 'instance_uuid'
          { 'task_state'     => "running", 'reboot_type' => options['force'] ? 'reset_power' : 'reboot_guest' }
        end

      end
    end
  end
end
