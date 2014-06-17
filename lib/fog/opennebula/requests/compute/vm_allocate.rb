module Fog
  module Compute
    class OpenNebula
      class Real
        def vm_allocate(attr={ })

          if(attr[:flavor].nil?)
            raise(ArgumentError.new("Attribute flavor is nil! #{attr.inspect}"))
          end
          if(attr[:name].nil? || attr[:name].empty?)
            raise(ArgumentError.new("Attribute name is nil or empty! #{attr.inspect}"))
          end

          xml = ::OpenNebula::VirtualMachine.build_xml
          vm  = ::OpenNebula::VirtualMachine.new(xml, client)
          rc = vm.allocate(attr[:flavor].to_s + "\nNAME=" + attr[:name])

          # irb(main):050:0> vm.allocate(s.flavor.to_s + "\nNAME=altest5")
          # => #<OpenNebula::Error:0x00000002a50760 @message="[VirtualMachineAllocate] User [42] : Not authorized to perform CREATE VM.", @errno=512>
          # irb(main):051:0> a = vm.allocate(s.flavor.to_s + "\nNAME=altest5")
          # => #<OpenNebula::Error:0x00000002ac0998 @message="[VirtualMachineAllocate] User [42] : Not authorized to perform CREATE VM.", @errno=512>
          # irb(main):052:0> a.class

          if(rc.is_a? ::OpenNebula::Error) 
            raise(rc)
          end


          # -1 - do not change the owner
          vm.chown(-1,attr[:gid].to_i) unless attr[:gid].nil?

          # TODO
          # check if vm is created vmid.class == One error class
          vm.info!

          one = vm.to_hash
          data = {}
          data["onevm_object"] = vm
          data["status"] =  vm.state
          data["state"]  =  vm.lcm_state_str
          data["id"]     =  vm.id
          data["uuid"]   =  vm.id
          data["gid"]    =  vm.gid
          data["name"]   =  one["VM"]["NAME"] unless one["VM"]["NAME"].nil?
          data["user"]   =  one["VM"]["UNAME"] unless one["VM"]["UNAME"].nil?
          data["group"]  =  one["VM"]["GNAME"] unless one["VM"]["GNAME"].nil?

          unless ( one["VM"]["TEMPLATE"].nil? ) then
            temp = one["VM"]["TEMPLATE"]
            data["cpu"]    =  temp["VCPU"] 	unless temp["VCPU"].nil?
            data["memory"] =  temp["MEMORY"] 	unless temp["MEMORY"].nil?
            unless (temp["NIC"].nil?) then
              if one["VM"]["TEMPLATE"]["NIC"].is_a?(Array)
                data["mac"]	=	temp["NIC"][0]["MAC"] 	unless temp["NIC"][0]["MAC"].nil?
                data["ip"]	=	temp["NIC"][0]["IP"] 	unless temp["NIC"][0]["IP"].nil?
              else
                data["mac"]	=	temp["NIC"]["MAC"] 	unless temp["NIC"]["MAC"].nil?
                data["ip"]	=	temp["NIC"]["IP"] 	unless temp["NIC"]["IP"].nil?
              end
            end
          end

          data
        rescue => err
          raise(err)
        end
      end

      class Mock
        def vm_allocate(attr={ })
          data = {}
          data["onevm_object"] = ""
          data["status"] = "Running"
          data["state"]  = "3"
          data["id"]     = 4
          data["uuid"]   = "5"
          data["gid"]    = "5"
          data["name"]   = "MockVM"
          data["user"]   = "MockUser" 
          data["group"]  = "MockGroup"
          data["cpu"]    = "2"
          data["memory"] = "1024"
          data["mac"]	 = "00:01:02:03:04:05"
          data["ip"]	 = "1.1.1.1"
          data
        end
      end
    end
  end
end
