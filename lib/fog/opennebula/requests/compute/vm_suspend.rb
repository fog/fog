module Fog
  module Compute
    class OpenNebula
      class Real
        def vm_suspend(id)
          vmpool = ::OpenNebula::VirtualMachinePool.new(client)
      	  vmpool.info!(-2,id,id,-1)

          vmpool.each do |vm|
            vm.suspend
          end
        end
      end

      class Mock
        def vm_suspend(id)
          response = Excon::Response.new
          response.status = 200

          self.data['vms'].each do |vm|
            if id == vm['id']
              vm['state'] = 'LCM_INIT'
              vm['status'] = 5
            end
          end

        end
      end
    end
  end
end
