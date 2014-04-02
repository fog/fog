module Fog
  module Compute
    class OpenNebula
      class Real

        def vm_destroy(id)
          vmpool = ::OpenNebula::VirtualMachinePool.new(client)
	  vmpool.info!(-2,id,id,-1)
	  puts "#{vmpool.entries.class} #{vmpool.entries.methods}"
	  puts "#{vmpool.entries.inspect} #{vmpool.entries.methods}"
          
	  vmpool.each do |vm|
            # true => delete and recreate vm
	    vm.delete(false)
          end
        end

        class Mock
        end
      end
    end
  end
end
