module Fog
  module Compute
    class Vsphere

      class Real
        include Shared

        def folder_parse(folder_path, folder_mob)
          # this function will parse the give folder-path and traverse on the inventory tree of vc
          # will create the folder if no find
          raise ArgumentError, "folder_path is a required parameter" unless folder_path
          path_elements = folder_path.split('/')
          path_elements.each do |f|
            Fog::Logger.debug("[#{Time.now.rfc2822}] Fog: folder name=#{f}")
            folder = folder_mob.traverse(f, RbVmomi::VIM::Folder, true)
            folder_mob = folder
          end
          folder_mob
        end

        def folder_create(dc_moid, folder_path)
          # this function will parse the give folder-path and traverse on the inventory tree of vc
          # will create the folder if no find
          raise ArgumentError, "folder_path is a required parameter" unless folder_path
          path_elements = folder_path.split('/')
          dc_mob = get_mob_ref_by_moid('Datacenter',dc_moid)
          folder_mob = dc_mob.vmFolder
          path_elements.each do |f|
            Fog::Logger.debug("[#{Time.now.rfc2822}] Fog: folder name=#{f}")
            folder = folder_mob.traverse(f, RbVmomi::VIM::Folder, true)
            folder_mob = folder
          end
          folder_mob
        end

        def folder_delete(dc_moid, folder_path)
          raise ArgumentError, "folder_path is a required parameter" unless folder_path
          rets = {'task_state' => 'false'}
          path_elements = folder_path.split('/')
          dc_mob = get_mob_ref_by_moid('Datacenter',dc_moid)
          folder_mob = dc_mob.vmFolder
          path_elements.each do |f|
            folder_mob = folder_mob.traverse(f, RbVmomi::VIM::Folder, false)
            Fog::Logger.debug("[#{Time.now.rfc2822}] Fog: folder_mob=#{folder_mob}")
            rets = {'task_state' => 'success'}
            return rets unless folder_mob
          end
          task = folder_mob.Destroy_Task
          wait_for_task(task)
          rets = {'task_state' => task.info.state}
        end
      end

    end
  end
end
