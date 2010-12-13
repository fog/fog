#!/usr/bin/env ruby

require 'rubygems'
require 'fog'

LINODE_API_KEY = '--put-your-key-here--'
SLICEHOST_PASSWORD = '--put-your-key-here--'
ZERIGO_USER = '--put-your-username-here--'
ZERIGO_PASSWORD = '--put-your-password-here--'


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
      master_zone_id = response.body['DATA']['DomainID']
    end
    
    #create a slave zone
    domain = 'sample-slave-domain.com'
    type = 'slave'
    options = { :master_ips => '1.2.3.4; 1.2.3.5'}
    response = cloud.domain_create( domain, type, options)
    if response.status == 200
      slave_zone_id = response.body['DATA']['DomainID']
    end

    #get a list of zones Linode hosted for account
    response = cloud.domain_list()
    if response.status == 200
      num_zones = response.body['DATA'].count
      puts "Linode is hosting #{num_zones} DNS zones for this account"
    end

    #add an A and a MX record
    options = { :name => 'www.sample-domain.com', :target => '4.5.6.7', :ttl_sec => 7200 }
    response = cloud.domain_resource_create( master_zone_id, 'A', options)
    if response.status == 200
      resource_id = response.body['DATA']['ResourceID']
    end

    options = { :target => 'mail.sample-domain.com', :priority => 1 }
    response = cloud.domain_resource_create( master_zone_id, 'MX', options)
    if response.status == 200
      resource_id = response.body['DATA']['ResourceID']
    end

    #change MX to have a lower priority
    options = { :priority => 5 }
    response = cloud.domain_resource_update( master_zone_id, resource_id, options)
    if response.status == 200
      resource_id = response.body['DATA']['ResourceID']
    end
    
    #get the list of resource records for the domain
    response = cloud.domain_resource_list( master_zone_id)
    if response.status == 200
      num_records = response.body['DATA'].count
      puts "Domain has #{num_records} records  for this domain"
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

# example of how to use Zerigo DNS calls
def show_zerigo_dns_usage( username, password)
  
  #check if we have a value api key for this cloud
  if username == '--put-your-username-here--'
    return false 
  end

  begin
    #connect to Zerigo
    options = { :zerigo_user => username, :zerigo_password => password }    
    cloud = Fog::Zerigo::Compute.new( options)

    #create a domain
    options = { :nx_ttl => 1800 }
    response = cloud.create_zone( "sample-domain.com", 3600, 'pri_sec', options) 
    if response.status == 201
      zone_id = response.body['id']
    end

    #update zone
    options = { :notes => "domain for client ABC"}
    response = cloud.update_zone( zone_id, options)
    if response.status == 200
      puts "update of zone #{zone_id} worked"
    end
    
    #get details on the zone
    response = cloud.get_zone( zone_id)
    if response.status == 200
      domain = response.body['domain']
      hosts = response.body['hosts']
    end
    
    #get zone stats    
    response = cloud.get_zone_stats( zone_id)
    if response.status == 200
      queries = response.body['queries']
    end
    
    #list all domains on this accont
    response= cloud.list_zones()
    if response.status == 200
      zone_count = response.headers['X-Query-Count'].to_i
    end
   
    #add an A record to the zone
    options = { :hostname => 'www' }
    response = cloud.create_host( zone_id, 'A', '1.2.3.4', options )
    if response.status == 201
      host_id = response.body['id']
    end
    
    #add an MX record to the zone
    options = { :priority => 5 }
    response = cloud.create_host( zone_id, 'MX', 'mail.sample-domain.com', options)
    if response.status == 201
      mail_host_id = response.body['id']
    end
    
    #update the record
    options = { :priority => 10 }
    response = cloud.update_host( mail_host_id, options)
    if response.status == 200
      #updated priority
    end
  
    #find a specific record
    response = cloud.find_hosts( "sample-domain.com" )
    if response.status == 200
      hosts= response.body['hosts']
      num_records = hosts.count
    end
    
    #get host record
    response = cloud.get_host( host_id)
    if response.status == 200
      fqdn = response.body['fqdn']
    end
    
    #list hosts
    response = cloud.list_hosts( zone_id)
    if response.status == 200
      hosts = response.body['hosts']
    end
    
    #delete the host record
    response = cloud.delete_host( host_id)
    if response.status == 200
      puts "host record #{host_id} deleted from zone"
    end
    
    #delete the zone we created
    response = cloud.delete_zone( zone_id)
    if response.status == 200
      puts "deleted zone #{zone_id}"
    end  
    
  rescue
    #opps, ran into a problem
    puts $!.message
    return false
  end
  
end

######################################

# note, if you have not added your key for a given provider, the related function will do nothing

show_linode_dns_usage( LINODE_API_KEY)
show_slicehost_dns_usage( SLICEHOST_PASSWORD)
show_zerigo_dns_usage( ZERIGO_USER, ZERIGO_PASSWORD)
