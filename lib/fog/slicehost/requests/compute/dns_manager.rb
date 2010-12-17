
# notes:  slicehost finds records by id - need to check if others do the same (for zones & records)
#         linode uses IDs
#

# array won't work because ID will change when delete items
# hash - but need to generate a unique number - counter

class DnsManager
  
  def initialize
    @zones = {}
    @zone_id_counter= 0
    @record_id_counter= 0
  end

  # add domain to list of zones and return a zone id.  note, only domain name is manatory.  any 
  # other desired fields can be included using options parameter
  def create_zone( domain, options)
    
    #see if domain already has zone
    zone_id= 0
    @zone.each { |id, zone|
      if domain.casecmp zone[:domain]
        zone_id= id
        break
      end
    }
    #if did not find, get a new zone ID
    if zone_id == 0
      zone_id= get_zone_id
    
    #add fields to zone 
    zone = { :domain => domain }
    options.each { |option, value|
      zone[option] = value
    }
    
    #add zone to dns manager
    @zones[zone_id] = zone
    
    zone_id
  end

  # update an existing zone with new data.  any field can be updated included domain name
  def update_zone( zone_id, domain, options)
    #build zone hash - merge?
    zone = {}
    @zones[zone_id] = zone
  end
  
  # remove a zone from the dns manager
  def delete_zone( zone_id)
    @zones.delete( zone_id)
  end
  
  # get 
  def get_zone( zone_id)
    @zones[zone_id]
  end
  
  
  #----------------------
  
  def get_zone_id
    @zone_id_counter+=1
  end
  private :get_zone_id
  
  def get_record_id
    @record_id_counter+=1
  end
  private :get_record_id
  
end