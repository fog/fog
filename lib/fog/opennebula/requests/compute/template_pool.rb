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
            # filtering by name
            # done here, because OpenNebula:TemplatePool does not support something like .delete_if
            if filter[:name] && filter[:name].is_a?(String) && !filter[:name].empty?
              next if t.to_hash["VMTEMPLATE"]["NAME"] != filter[:name]
            end
            if filter[:uname] && filter[:uname].is_a?(String) && !filter[:uname].empty?
              next if t.to_hash["VMTEMPLATE"]["UNAME"] != filter[:uname]
            end
            if filter[:uid] && filter[:uid].is_a?(String) && !filter[:uid].empty?
              next if t.to_hash["VMTEMPLATE"]["UID"] != filter[:uid]
            end

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
              #nics["uuid"] = "0" if nics["uuid"].nil? # is it better is to remove this NIC?
              n = networks.get_by_filter({
                :id => nics["NETWORK_ID"],
                :network => nics["NETWORK"],
                :network_uname => nics["NETWORK_UNAME"],
                :network_uid => nics["NETWORK_UID"]
              })
              h["NIC"] << interfaces.new({ :vnet => n })
            else
              # should i break?
            end

          
            # every key should be lowercase
            ret_hash = {}
            h.each_pair do |k,v| 
              ret_hash.merge!({k.downcase => v}) 
            end
            ret_hash
          end
          
          templates.delete nil
          raise Fog::Compute::OpenNebula::NotFound, "Flavor/Template not found" if templates.empty?
          templates
        end #def template_pool
      end #class Real

      class Mock
        def template_pool(filter = { })
          [ {}, {} ]
        end
      end #class Mock
    end #class OpenNebula
  end #module Compute
end #module Fog
