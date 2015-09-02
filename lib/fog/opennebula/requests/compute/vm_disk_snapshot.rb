module Fog
  module Compute
    class OpenNebula
      class Real

        def vm_disk_snapshot(id, disk_id, image_name)
          vmpool = ::OpenNebula::VirtualMachinePool.new(client)
          vmpool.info!(-2,id,id,-1)

          rc = 0
          vmpool.each do |vm|
            rc = vm.disk_snapshot(disk_id, image_name)
            if(rc.is_a? ::OpenNebula::Error)
               raise(rc)
            end
          end
          rc
        end #def vm_disk_snapshot
      end
    end
  end
end
