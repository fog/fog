# t.template_str
# CPU="0.2"
# VCPU="2"
# MEMORY="2048"
# SCHED_REQUIREMENTS="NFS=\"true\""
# SCHED_DS_REQUIREMENTS="NAME=\"local\""
# DISK=[
#     DEV_PREFIX="vd",
#     DRIVER="qcow2",
#     IMAGE="base",
#     IMAGE_ID="355",
#     IMAGE_UNAME="oneadmin",
#     TARGET="vda" ]
# GRAPHICS=[
#     LISTEN="0.0.0.0",
#      TYPE="VNC" ]
# NIC=[
#     MODEL="virtio",
#     NETWORK="vlan2-2",
#     NETWORK_UNAME="oneadmin" ]
# OS=[
#     ARCH="x86_64",
#     BOOT="network,hd" ]


module Fog
  module Compute
    class OpenNebula
      class Real
        def template_pool(filter = { })

          templates = ::OpenNebula::TemplatePool.new(client)
          if filter[:id].nil?
            templates.info!(-2,-1,-1)
          elsif filter[:id]
            filter[:id] = filter[:id].to_i if filter[:id].is_a?(String)
            templates.info!(-2, filter[:id], filter[:id])
          end # if filter[:id].nil?

          templates = templates.map do |t| 
            h = Hash[
              :id => t.to_hash["VMTEMPLATE"]["ID"], 
              :name => t.to_hash["VMTEMPLATE"]["NAME"], 
              :content => t.template_str
            ]
            h.merge! t.to_hash["VMTEMPLATE"]["TEMPLATE"]

            # h["NIC"] has to be an array of nic objects
            nics = h["NIC"] unless h["NIC"].nil?
            h["NIC"] = [] # reset nics to a array
            if nics.is_a? Array
              nics.each do |n|
                n["model"] = "virtio" if n["model"].nil?
                n["uuid"] = "0" if n["uuid"].nil? # is it better is to remove this NIC?
                h["NIC"] << interfaces.new({ :vnet => networks.get(n["uuid"]), :model => n["model"]})
              end
            elsif nics.is_a? Hash
              nics["model"] = "virtio" if nics["model"].nil?
              nics["uuid"] = "0" if nics["uuid"].nil? # is it better is to remove this NIC?
              h["NIC"] << interfaces.new({ :vnet => networks.get(nics["uuid"]), :model => nics["model"]})
            else
              # should i break?
            end

            h
	  end

          templates 
        end #def template_pool
      end #class Real

      class Mock
      end #class Mock
    end #class OpenNebula
  end #module Compute
end #module Fog
