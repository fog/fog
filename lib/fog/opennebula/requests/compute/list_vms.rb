#{"VM"=>{"ID"=>"30", "UID"=>"0", "GID"=>"0", "UNAME"=>"oneadmin", "GNAME"=>"oneadmin", "NAME"=>"m1.small-30", "PERMISSIONS"=>{"OWNER_U"=>"1", "OWNER_M"=>"1", "OWNER_A"=>"0", "GROUP_U"=>"0", "GROUP_M"=>"0", "GROUP_A"=>"0", "OTHER_U"=>"0", "OTHER_M"=>"0", "OTHER_A"=>"0"}, "LAST_POLL"=>"0", "STATE"=>"1", "LCM_STATE"=>"0", "RESCHED"=>"0", "STIME"=>"1395937874", "ETIME"=>"0", "DEPLOY_ID"=>{}, "MEMORY"=>"0", "CPU"=>"0", "NET_TX"=>"0", "NET_RX"=>"0", "TEMPLATE"=>{"AUTOMATIC_REQUIREMENTS"=>"!(PUBLIC_CLOUD = YES)", "CONTEXT"=>{"DISK_ID"=>"2", "EC2_KEYNAME"=>"foreman-1b028a80e-2c8e-4582-a718-960ab6531eb3", "EC2_PUBLIC_KEY"=>"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDN/8DRFSrYoox1wqZfOUGpDxP4C906kgaHEQ3UEV0536VCBmGgG4flQ3C4Smf9zYrWPuQNqLt7KHzODlrWcSj9Bo98u7HbSUW386A3mIXJ8ujUxTQsIoKb0U+/eKjTCB21mjr8RFKAADRKtCQQkNMvJxrZ3/05QDvproprukyFY5R8se6EMTLit46s33QJaVF82q/Bbhzqd2cfx72TusXUp8bo/w5SBgr4VjFewke82VD6flBMLACkAQhDh200fwsjaEb4NUuUSvS5gfha3okjlVvcSLBaDkQftW0/VuUTjDi7wZbBKeu1SS2MpKTYBDrsi+bcmlJmvbwadBncCbGh foreman-1b028a80e-2c8e-4582-a718-960ab6531eb3", "ETH0_IP"=>"192.168.17.0", "ETH0_MAC"=>"02:00:c0:a8:11:00", "ETH0_MASK"=>"255.255.255.0", "ETH0_NETWORK"=>"192.168.17.0", "NETWORK"=>"YES", "TARGET"=>"hdb"}, "CPU"=>"1", "DISK"=>[{"CLONE"=>"YES", "CLONE_TARGET"=>"SYSTEM", "DATASTORE"=>"default", "DATASTORE_ID"=>"1", "DEV_PREFIX"=>"hd", "DISK_ID"=>"0", "DRIVER"=>"qcow2", "IMAGE"=>"testimage", "IMAGE_ID"=>"0", "LN_TARGET"=>"NONE", "READONLY"=>"NO", "SAVE"=>"NO", "SIZE"=>"218", "SOURCE"=>"/var/lib/one//datastores/1/5c3ff6087ee30b4f5ac7626ed66cfcc6", "TARGET"=>"hda", "TM_MAD"=>"shared", "TYPE"=>"FILE"}, {"CLONE"=>"YES", "CLONE_TARGET"=>"SYSTEM", "DATASTORE"=>"default", "DATASTORE_ID"=>"1", "DEV_PREFIX"=>"hd", "DISK_ID"=>"1", "IMAGE"=>"ec2-c29e8235-249e-4a1e-b818-5703140a1133", "IMAGE_ID"=>"2", "IMAGE_UNAME"=>"oneadmin", "LN_TARGET"=>"NONE", "READONLY"=>"NO", "SAVE"=>"NO", "SIZE"=>"1024", "SOURCE"=>"/var/lib/one//datastores/1/346ee4cb31e9a3a6d119add759cf2824", "TARGET"=>"hdc", "TM_MAD"=>"shared", "TYPE"=>"FILE"}], "MEMORY"=>"512", "NIC"=>{"BRIDGE"=>"br0", "IP"=>"192.168.17.0", "IP6_LINK"=>"fe80::400:c0ff:fea8:1100", "MAC"=>"02:00:c0:a8:11:00", "NETWORK"=>"vlan17", "NETWORK_ID"=>"0", "NETWORK_UNAME"=>"oneadmin", "NIC_ID"=>"0", "VLAN"=>"YES", "VLAN_ID"=>"17"}, "TEMPLATE_ID"=>"3", "VMID"=>"30"}, "USER_TEMPLATE"=>{"EC2_INSTANCE_TYPE"=>"m1.small", "EC2_TAGS"=>{"NAME"=>"test.example.com"}, "SCHED_MESSAGE"=>"Tue Apr  1 15:01:22 2014 : No host with enough capacity to deploy the VM"}, "HISTORY_RECORDS"=>{}}}

module Fog
  module Compute
    class OpenNebula
      class Real
        def list_vms(filter={})
          vms=[]
          vmpool = ::OpenNebula::VirtualMachinePool.new(client)
          if filter[:id].nil?
            vmpool.info!(-2,-1,-1,-1)
          elsif filter[:id]
            filter[:id] = filter[:id].to_i if filter[:id].is_a?(String)
            vmpool.info!(-2, filter[:id], filter[:id], -1)
          end # filter[:id].nil?

          vmpool.each do |vm|
            one = vm.to_hash
            data = {}
            data["onevm_object"] = vm
            data["status"] =  vm.state
            data["state"]  =  vm.lcm_state_str
            data["id"]     =  vm.id
            data["gid"]    =  vm.gid
            data["uuid"]   =  vm.id
            data["name"]   =  one["VM"]["NAME"] unless one["VM"]["NAME"].nil?
            data["user"]   =  one["VM"]["UNAME"] unless one["VM"]["UNAME"].nil?
            data["group"]  =  one["VM"]["GNAME"] unless one["VM"]["GNAME"].nil?

            unless ( one["VM"]["TEMPLATE"].nil? ) then
              data["cpu"]    =  one["VM"]["TEMPLATE"]["VCPU"] unless one["VM"]["TEMPLATE"]["VCPU"].nil?
              data["memory"] =  one["VM"]["TEMPLATE"]["MEMORY"] unless one["VM"]["TEMPLATE"]["MEMORY"].nil?
              unless (one["VM"]["TEMPLATE"]["NIC"].nil?) then
                if one["VM"]["TEMPLATE"]["NIC"].is_a?(Array)
                  data["ip"]=one["VM"]["TEMPLATE"]["NIC"][0]["IP"]
                  data["mac"]=one["VM"]["TEMPLATE"]["NIC"][0]["MAC"]
                else
                  data["ip"]=one["VM"]["TEMPLATE"]["NIC"]["IP"] unless one["VM"]["TEMPLATE"]["NIC"]["IP"].nil?
                  data["mac"]=one["VM"]["TEMPLATE"]["NIC"]["MAC"] unless one["VM"]["TEMPLATE"]["NIC"]["MAC"].nil?
                end
              end # unless (one["VM"]["TEMPLATE"]["NIC"].nil?) then
            end # unless ( one["VM"]["TEMPLATE"].nil? ) then 

            vms << data
          end # vmpool.each
          vms
        end # def list_vms
      end # class Real

      module Shared
        private
      end

      class Mock
        def list_vms(filter = {})
          vms = []
          self.data['vms'].each do |vm|
            if filter[:id].nil?
              vms << vm
            elsif filter[:id] == vm['id']
              vms << vm
            end
          end
          vms
        end
      end
    end
  end
end
