module Fog
  module Compute
    class OpenNebula
      class Real

        def vm_resume(id)

          vmpool = ::OpenNebula::VirtualMachinePool.new(client)
	  vmpool.info!(-2,id,id,-1)
	  puts "#{vmpool.entries.class} #{vmpool.entries.methods}"
	  puts "#{vmpool.entries.inspect} #{vmpool.entries.methods}"
          
	  vmpool.each do |vm|
	    vm.resume
          end
          ##if(attr[:id].nil?) 
	  ##  raise(ArgumentError.new("Attribute :id is nil or empty! #{attr.inspect}"))
	  ##end

          #vmpool = ::OpenNebula::VirtualMachinePool.new(client)
	  #vmpool.info!

	  #vmpool.each do |vm|
	  #        if vm.id == id then
	  #      	  vm.resume
	  #      	  return true
	  #        end
	  #end
	  #false
        end

        class Mock
        end
      end
    end
  end
end
