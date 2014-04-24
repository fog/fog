module Fog
  module Compute
    class OpenNebula
      class Real
        def list_groups(filter = { })

          groups=[]
          grouppool = ::OpenNebula::GroupPool.new(client)
	  grouppool.info
 
	  # {
	  #   "GROUP"=>{
	  #     "ID"=>"0", 
	  #      "NAME"=>"oneadmin", 
	  #      "USERS"=>{"ID"=>["0", "1"]}, 
	  #      "DATASTORE_QUOTA"=>{}, 
	  #      "NETWORK_QUOTA"=>{}, 
	  #      "VM_QUOTA"=>{}, 
	  #      "IMAGE_QUOTA"=>{}
          #    }
	  #}
          grouppool.each do |group| 
	    puts "GROUP #{group.to_hash.display}"
	    groups << {:id => group["ID"], :name => group["NAME"]}
	  end
	  puts "GROUPS #{groups.inspect}"
          groups
        end


      end

      class Mock
      end
    end
  end
end
