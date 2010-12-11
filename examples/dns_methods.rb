#!/usr/bin/env ruby

require 'rubygems'
# require 'fog'
require '/Users/anuaimi/code/fog/lib/fog'

LINODE_API_KEY = '--put-your-key-here--'
SLICEHOST_PASSWORD = '--put-your-key-here--'


# example of how to use Linode DNS calls
def show_linode_dns_usage( api_key)
  
  if api_key == '--put-your-key-here--'
    return false 
  end

  begin
    #connect to Linode
    options = { :linode_api_key => api_key }    
    cloud= Fog::Linode::Compute.new( options)

    #create a zone for a domain
    domain = 'sample-domain.com'
    type = 'master'
    options = { :SOA_email => 'netops@sample-domain.com', :description => "Sample-Domain Inc", :status => 0}
    response = cloud.domain_create( domain, type, options)
    if response.status == 200
      master_zone_id = response.body['DATA']['DOMAINID']
    end
    
    #create a slave zone
    domain = 'sample-slave-domain.com'
    type = 'slave'
    options = { :master_ips => '1.2.3.4; 1.2.3.5'}
    response = cloud.domain_create( domain, type, options)
    if response.status == 200
      slave_zone_id = response.body['DATA']['DOMAINID']
    end
    
    #add an A record for website 
    
    #get a list of zones Linode hosted for account
    response = cloud.domain_list()
    if response.status == 200
      num_zones = response.body['DATA'].count
      puts "Linode is hosting #{num_zones} DNS zones for this account"
    end
        
    #finally cleanup by deleting the zone we created
    response = cloud.domain_delete( master_zone_id)
    if response.status == 200
      puts "master zone deleted"
    end
    response = cloud.domain_delete( slave_zone_id)
    if response.status == 200
      puts "slave zone deleted"
    end
       
  rescue
    #opps, ran into a problem
    puts $!.message
    return false
  end

  true
end

# example of how to use Slicehost DNS calls
def show_slicehost_dns_usage( password)
  
  #check if we have a value api key for this cloud
  if password == '--put-your-key-here--'
    return false 
  end

  begin
    #connect to Slicehost
    options = { :slicehost_password => password }    
    cloud= Fog::Slicehost::Compute.new( options)
    
    #create a zone for a domain
    zone_id = 0
    options = { :ttl => 1800, :active => 'N' }
    response= cloud.create_zone( "sample-domain.com", options)
    if response.status == 200
      zone_id= response.body['id']
    end
    
    #add an A record for website 
    record_id = 0
    options = { :ttl => 3600, :active => 'N' }
    response= cloud.create_record( 'A', 159631, "www.sample-domain.com", "1.2.3.4", options)
    if response.status == 200
      record_id= response.body['id']
    end
    
    #get a list of zones Slicehost hosted for account
    response = cloud.get_zones()
    if response.status == 200
      num_zones= response.body['zones'].count
      puts "Slicehost is hosting #{num_zones} DNS zones for this account"
    end
  
    #now get details on www record for the zone
    if record_id > 0
      response = cloud.get_record( record_id)
      if response.status == 200
        record = response.body['records'][0]
        name = record['name']
        type = record['record-type']
        puts "record is an #{type} record for #{name} domain"
      end
    end
  
    #finally cleanup by deleting the zone we created
    if zoned_id > 0
      response = cloud.delete_zone( zone_id)
      if response.status == 200
        puts "sample-domain.com removed from Slicehost DNS"
      end
    end
      
  rescue 
    #opps, ran into a problem
    puts $!.message
    return false
  end

  true
end


######################################

# note, if you have not added your key for a given provider, the related function will do nothing

show_linode_dns_usage( LINODE_API_KEY)
show_slicehost_dns_usage( SLICEHOST_PASSWORD)
