module Fog
  module Compute
    class OpenNebula
      class Real

        def vm_shutdown(id)
          vmpool = ::OpenNebula::VirtualMachinePool.new(client)
         vmpool.info!(-2,id,id,-1)

         vmpool.each do |vm|
           vm.shutdown()
          end
        end #def vm_disk_snapshot

      end
      class Mock
        def vm_shutdown(id)
          true
        end
      end
    end
  end
end
