module Fog
  module Compute
    class OpenNebula
      class Real

        def vm_allocate(attr={ })

          if(attr[:flavor].nil?)
            raise(ArgumentError.new("Attribute flavor is nil or empty! #{attr.inspect}"))
          end

          puts "flavor: #{attr[:flavor].inspect}"
          puts attr[:flavor].to_s

          #	  xml = ::OpenNebula::Template.build_xml(12)
          #	  template = ::OpenNebula::Template.new(xml, client)
          #	  puts "TEmplate #{template.inspect}"
          ##	  template.update(attr[:flavor].to_s)
          ##	  puts "TEmplate update #{template.inspect}"
          #	  vmid = template.instantiate(name = attr[:name], hold = false, template = attr[:flavor].to_s)
          #	  puts "VMID #{vmid.inspect}"

          xml = ::OpenNebula::VirtualMachine.build_xml
          vm  = ::OpenNebula::VirtualMachine.new(xml, client)
          vm.allocate(attr[:flavor].to_s + "\nNAME=" + attr[:name])
          vmid = vm.id

          # TODO
          # check if vm is created vmid.class == One error class

          vmpool = ::OpenNebula::VirtualMachinePool.new(client)
          vmpool.info!(-2, vmid, vmid, -1)
          vm = vmpool.entries.first

          vm.info!
          one = vm.to_hash

          data = {}
          data["status"] =  vm.state
          data["state"]  =  vm.lcm_state_str
          data["id"]     =  vm.id
          data["uuid"]   =  vm.id
          data["name"]   =  one["VM"]["NAME"] unless one["VM"]["NAME"].nil?
          data["user"]   =  one["VM"]["UNAME"] unless one["VM"]["UNAME"].nil?
          data["group"]  =  one["VM"]["GNAME"] unless one["VM"]["GNAME"].nil?

          unless ( one["VM"]["TEMPLATE"].nil? ) then
            temp = one["VM"]["TEMPLATE"]
            data["cpu"]    =  temp["VCPU"] 	unless temp["VCPU"].nil?
            data["memory"] =  temp["MEMORY"] 	unless temp["MEMORY"].nil?
            unless (temp["NIC"].nil?) then
              data["mac"]	=	temp["NIC"]["MAC"] 	unless temp["NIC"]["MAC"].nil?
              data["ip"]	=	temp["NIC"]["IP"] 	unless temp["NIC"]["IP"].nil?
            end
          end

          data
        end
      end

      class Mock
      end
    end
  end
end
