#!/usr/bin/env ruby

require 'rubygems'
require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib', 'fog')
require 'fog/core/bin'

#mark true for each cloud you wish to enable/run the sample for
RUN_AWS_SAMPLE = true
RUN_LINODE_SAMPLE = false
RUN_SLICEHOST_SAMPLE = false
RUN_ZERIGO_SAMPLE = false

#domain to use in examples
TEST_DOMAIN = 'test-343246324434.com'

# example of how to use AWS Route 53 DNS calls
def show_aws_dns_usage

  begin    
    
    #use to keep track of zone we create
    zone_id= nil
    
    # see if domain is already hosted on AWS
    # important to check as AWS will let you create multiple zones with the same domain name
    options= { :max_items => 200 }
    response = AWS[:dns].list_hosted_zones( options)
    if response.status == 200
      zones = response.body['HostedZones']
      zones.each { |zone|
        domain_name = zone['Name']
        if domain_name.chop == TEST_DOMAIN
          zone_id = zone['Id'].sub('/hostedzone/', '')
        end
      }
    end
    
    #if domain not yet created, do so now
    if zone_id.nil?
      options= { :comment => 'test domain - not for production use' }
      response = AWS[:dns].create_hosted_zone( TEST_DOMAIN, options)
      if response.status == 201
        zone_id = response.body['HostedZone']['Id']
        change_id = response.body['ChangeInfo']['Id']
        status = response.body['ChangeInfo']['Status']
      end
    end
    
    #get details about zone including name servers (which AWS adds automatically)
    response = AWS[:dns].get_hosted_zone( zone_id)
    if response.status == 200
      zone_info = response.body['HostedZone']
      name_servers = response.body['NameServers']
      num_ns_servers = name_servers.count
    end

    #add an A record for www
    change_batch = []
    host = 'www.' + TEST_DOMAIN
    ip_addr = '1.2.3.4'
    record = { :name => host, :type => 'A', :resource_records => [ip_addr], :ttl => 3600 }
    
    resource_record_set = record.merge( :action => 'CREATE' )
    change_batch << resource_record_set
    options = { :comment => 'add A record for www'}
    response = AWS[:dns].change_resource_record_sets( zone_id, change_batch, options)
    if response.status == 200
      change_id = response.body['Id']
      status = response.body['Status']
    end
    
    debugger

    #wait until new zone is live across all name servers
    while status == 'PENDING'
      sleep 2
      response = AWS[:dns].get_change( change_id)
      if response.status == 200
        change_id = response.body['Id']
        status = response.body['Status']
      end
      puts "your changes are #{status}"    
    end

    # get resource records for zone
    response = AWS[:dns].list_resource_record_sets( zone_id)
    if response.status == 200
      record_sets= response.body['ResourceRecordSets']
      num_records= record_sets.count
    end

    #now delete record for www
    resource_record_set = record.merge( :action => 'DELETE' )
    change_batch = []
    change_batch << resource_record_set
    options = { :comment => 'remove A record for www'}
    response = AWS[:dns].change_resource_record_sets( zone_id, change_batch, options)
    if response.status == 200
      change_id = response.body['Id']
      status = response.body['Status']
    end
    
    #delete the zone
    response = AWS[:dns].delete_hosted_zone( zone_id)
    if response.status == 200
      change_id = response.body['ChangeInfo']['Id']
    end


  rescue 
    #opps, ran into a problem
    puts $!.message
    return false
  end

  true
end


# example of how to use Linode DNS calls
def show_linode_dns_usage
  
  begin
    
    #create a zone for a domain
    type = 'master'
    options = { :SOA_email => 'netops@sample-domain.com', :description => "Sample-Domain Inc", :status => 0}
    response = Linode[:compute].domain_create( TEST_DOMAIN, type, options)
    if response.status == 200
      master_zone_id = response.body['DATA']['DomainID']
      puts "created zone for #{TEST_DOMAIN} - ID: #{master_zone_id}"
    end
    
    #create a slave zone
    domain = 'sample-slave-domain.com'
    type = 'slave'
    options = { :master_ips => '1.2.3.4; 1.2.3.5'}
    response = Linode[:compute].domain_create( domain, type, options)
    if response.status == 200
      slave_zone_id = response.body['DATA']['DomainID']
      puts "created slave zone for #{domain} - ID: #{slave_zone_id}"
    end

    #get a list of zones Linode hosted for account
    response = Linode[:compute].domain_list()
    if response.status == 200
      zones = response.body['DATA']
      num_zones = zones.count
      puts "Linode is hosting #{num_zones} DNS zones for this account:"
      zones.each { |zone|
        puts "  #{zone['DOMAIN']}\n"
      }
    end

    #add an A and a MX record
    domain= 'www.' + TEST_DOMAIN
    options = { :name => domain, :target => '4.5.6.7', :ttl_sec => 7200 }
    response = Linode[:compute].domain_resource_create( master_zone_id, 'A', options)
    if response.status == 200
      resource_id = response.body['DATA']['ResourceID']
      puts "added an A record for #{domain} - ID: #{resource_id}"
    end

    domain= 'mail.' + TEST_DOMAIN
    options = { :target => domain, :priority => 1 }
    response = Linode[:compute].domain_resource_create( master_zone_id, 'MX', options)
    if response.status == 200
      resource_id = response.body['DATA']['ResourceID']
      puts "added a MX record for #{TEST_DOMAIN} - ID: #{resource_id}"
    end

    #change MX to have a lower priority
    options = { :priority => 5 }
    response = Linode[:compute].domain_resource_update( master_zone_id, resource_id, options)
    if response.status == 200
      resource_id = response.body['DATA']['ResourceID']
      puts "updated MX record for #{TEST_DOMAIN} with new priority - ID: #{resource_id}"      
    end
    
    #get the list of resource records for the domain
    response = Linode[:compute].domain_resource_list( master_zone_id)
    if response.status == 200
      num_records = response.body['DATA'].count
      puts "#{TEST_DOMAIN} zone has #{num_records} resource records"
    end

    #finally cleanup by deleting the zone we created
    response = Linode[:compute].domain_delete( master_zone_id)
    if response.status == 200
      puts "deleted #{TEST_DOMAIN} zone"
    end
    response = Linode[:compute].domain_delete( slave_zone_id)
    if response.status == 200
      puts "deleted slave zone"
    end
       
  rescue
    #opps, ran into a problem
    puts $!.message
    return false
  end

  true
end


# example of how to use Slicehost DNS calls
def show_slicehost_dns_usage
  
  begin
    #create a zone for a domain
    zone_id = 0
    options = { :ttl => 1800, :active => 'N' }
    response= Slicehost[:compute].create_zone( TEST_DOMAIN, options)
    if response.status == 201
      zone_id= response.body['id']
      puts "created zone for #{TEST_DOMAIN} - ID: #{zone_id}"
    end
    
    #add an A record for website 
    record_id = 0
    options = { :ttl => 3600, :active => 'N' }
    host = "www.#{TEST_DOMAIN}"
    response= Slicehost[:compute].create_record( 'A', zone_id, host, "1.2.3.4", options)
    if response.status == 201
      record_id= response.body['id']
      puts "created 'A' record for #{host} - ID: #{record_id}"
    end
    
    #get a list of zones Slicehost hosted for account
    response = Slicehost[:compute].get_zones()
    if response.status == 200
      zones = response.body['zones']
      num_zones= zones.count
      puts "Slicehost is hosting #{num_zones} DNS zones for this account"
      zones.each { |zone|
        puts "  #{zone['origin']}\n"
      }
    end
  
    #now get details on www record for the zone
    if record_id > 0
      response = Slicehost[:compute].get_record( record_id)
      if response.status == 200
        record = response.body['records'][0]
        name = record['name']
        type = record['record-type']
        puts "got details on record #{record_id} -is an #{type} record for #{name} domain"
      end
    end
  
    #finally cleanup by deleting the zone we created
    if zone_id > 0
      response = Slicehost[:compute].delete_zone( zone_id)
      if response.status == 200
        puts "#{TEST_DOMAIN} removed from Slicehost DNS"
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
def show_zerigo_dns_usage
  
  begin
    #create a domain
    options = { :nx_ttl => 1800 }
    response = Zerigo[:compute].create_zone( "sample-domain.com", 3600, 'pri_sec', options)
    if response.status == 201
      zone_id = response.body['id']
    end

    #update zone
    options = { :notes => "domain for client ABC"}
    response = Zerigo[:compute].update_zone( zone_id, options)
    if response.status == 200
      puts "update of zone #{zone_id} worked"
    end
    
    #get details on the zone
    response = Zerigo[:compute].get_zone( zone_id)
    if response.status == 200
      domain = response.body['domain']
      hosts = response.body['hosts']
    end
    
    #get zone stats    
    response = Zerigo[:compute].get_zone_stats( zone_id)
    if response.status == 200
      queries = response.body['queries']
    end
    
    #list all domains on this accont
    response= Zerigo[:compute].list_zones()
    if response.status == 200
      zone_count = response.headers['X-Query-Count'].to_i
    end
   
    #add an A record to the zone
    options = { :hostname => 'www' }
    response = Zerigo[:compute].create_host( zone_id, 'A', '1.2.3.4', options )
    if response.status == 201
      host_id = response.body['id']
    end
    
    #add an MX record to the zone
    options = { :priority => 5 }
    response = Zerigo[:compute].create_host( zone_id, 'MX', 'mail.sample-domain.com', options)
    if response.status == 201
      mail_host_id = response.body['id']
    end
    
    #update the record
    options = { :priority => 10 }
    response = Zerigo[:compute].update_host( mail_host_id, options)
    if response.status == 200
      #updated priority
    end
  
    #find a specific record
    response = Zerigo[:compute].find_hosts( "sample-domain.com" )
    if response.status == 200
      hosts= response.body['hosts']
      num_records = hosts.count
    end
    
    #get host record
    response = Zerigo[:compute].get_host( host_id)
    if response.status == 200
      fqdn = response.body['fqdn']
    end
    
    #list hosts
    response = Zerigo[:compute].list_hosts( zone_id)
    if response.status == 200
      hosts = response.body['hosts']
    end
    
    #delete the host record
    response = Zerigo[:compute].delete_host( host_id)
    if response.status == 200
      puts "host record #{host_id} deleted from zone"
    end
    
    #delete the zone we created
    response = Zerigo[:compute].delete_zone( zone_id)
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

# make sure Fog credentials file has been setup 
# (will throw exception if not)
Fog::credentials

# AWS Route 53
if RUN_AWS_SAMPLE and Fog::credentials[:aws_access_key_id] and Fog::credentials[:aws_secret_access_key]
  show_aws_dns_usage
end

# Linode
if RUN_LINODE_SAMPLE and Fog::credentials[:linode_api_key]
  show_linode_dns_usage
end

# Slicehost
if RUN_SLICEHOST_SAMPLE and Fog::credentials[:slicehost_password]
  show_slicehost_dns_usage
end

if RUN_ZERIGO_SAMPLE and Fog::credentials[:zerigo_email] and Fog::credentials[:zerigo_password]
  show_zerigo_dns_usage
end
