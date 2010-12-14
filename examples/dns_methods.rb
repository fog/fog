#!/usr/bin/env ruby

require 'rubygems'
require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'lib', 'fog')
require 'fog/core/bin'

Fog.bin = true

#mark true for each cloud you wish to enable/run the sample for
RUN_AWS_SAMPLE = true
RUN_LINODE_SAMPLE = true
RUN_SLICEHOST_SAMPLE = false
RUN_ZERIGO_SAMPLE = false

#sample data 
TEST_DOMAIN='sample53-domain.com'


# example of how to use AWS Route 53 DNS calls
def show_aws_dns_usage

  begin    
    
    aws = AWS[:dns].list_hosted_zones

    debugger
    
    response = AWS[:dns].create_hosted_zone( TEST_DOMAIN)
    if response.status == 201
      zone_id = response.body['HostedZone']['Id']
      aws.delete_hosted_zone( zone_id)
      (response.status == 200) ? true : false
    end

    #get a list of the zones AWS is hosting for this account
    options= { :max_items => 50 }
    response= AWS[:dns].list_hosted_zones( options)
    if response.status == 200
      domain_count = response.body['HostedZones'].count
      puts "you have #{domain_count} zones hosted at AWS Route 53"
    end

    # debugger
        
    #delete all the zones
    zones= response.body['HostedZones']
    zones.each { |zone|

      zone_id = zone['Id']
      puts "starting process of deleting zone #{zone_id}"

      #get the list of record sets
      options = { :max_items => 50 }
      response = AWS[:dns].list_resource_record_sets( zone_id, options)
      if response.status == 200
        records= response.body['ResourceRecordSets']
        count= records.count
        
        if count > 0
          puts "#{count} resource records to delete"
          #need to build a change batch
          change_batch = []
          records.each { |record|
            #can't delete NS or SOA that AWS added so skip 
            if record[:type] == 'NS' or record[:type] == 'SOA'
              continue
            else
              #add to batch of records to delete
              resource_record_set = { :action => 'DELETE', :name => record['Name'], :type => record['Type'],
                                      :ttl => record['TTL'], :resource_records => record['ResourceRecords'] }
              change_batch << resource_record_set
            end
          }
          
          if change_batch.count > 0
            response = AWS[:dns].change_resource_record_sets( zone_id, change_batch)
            debugger
            if response.status == 200
              #zone should now be in a state where it can be deleted
            end
          end
          
        end
        
      end
      
      #delete the records
      
      response = AWS[:dns].delete_hosted_zone( zone_id)
      if response.status == 200
        change_id = response.body['ChangeInfo']['Id']
        puts "request delete zone #{zone_id} is in progress and has change ID #{change_id}"
      end

    }

    # debugger
    
    #add a zone - note required period at end of domain
    options= { :comment => 'for client ABC' }
    response= AWS[:dns].create_hosted_zone( 'sample-domain.com.' )
    if response.status == 201
      zone_id = response.body['HostedZone']['Id']
      change_id = response.body['ChangeInfo']['Id']
      status = response.body['ChangeInfo']['Status']
    end

    # debugger
    
    #wait until zone ready
    while status == 'PENDING'
      sleep 2
      response = AWS[:dns].get_change( change_id)
      if response.status == 200
        change_id = response.body['Id']
        status = response.body['Status']
      end
      puts "your changes are #{status}"    
    end

    # debugger
    
    response = AWS[:dns].get_hosted_zone( zone_id)
    if response.status == 200
      name_servers = response.body['NameServers']
    end

    debugger
    
    #add resource records to zone
    change_batch = []
    resource_record_set = { :action => 'CREATE', :name => 'www.sample-domain.com.', :type => 'A',
                        :ttl => 3600, :resource_records => ['1.2.3.4'] }
    change_batch << resource_record_set
=begin
    resource_record_set = { :action => 'CREATE', :name => 'mail.sample-domain.com.', :type => 'CNAME',
                        :ttl => 3600, :resource_records => ['www.sample-domain.com'] }
    change_batch << resource_record_set
    resource_record_set = { :action => 'CREATE', :name => 'sample-domain.com.', :type => 'MX',
                        :ttl => 3600, :resource_records => ['10 mail.sample-domain.com'] }
    change_batch << resource_record
=end    
    options = { :comment => 'migrate records from BIND'}
    response = AWS[:dns].change_resource_record_sets( zone_id, change_batch, options)
    if response.status == 200
      change_id = response.body['Id']
      status = response.body['Status']
    end
    
    debugger
    
    #wait until zone ready
    while status == 'PENDING'
      sleep 2
      response = AWS[:dns].get_change( change_id)
      if response.status == 200
        change_id = response.body['Id']
        status = response.body['Id']
      end
      puts "your changes are #{status}"
    end
    
    #get a list of the zones AWS is hosting for this account
    options= { :max_items => 5 }
    response= AWS[:dns].list_hosted_zones( )
    if response.status == 200
    end
    
    response = AWS[:dns].get_hosted_zone()
    if response.status == 200
    end
    
    response = AWS[:dns].list_resource_record_sets
    if response.status == 200
    end
    
    #delete the resource records
    response = AWS[:dns].change_resource_record_sets( zone_id, change_batch, options)
    if response.status == 200
      change_id = response.body['ChangeInfo']['Id']
    end

    #wait?
    
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

# if RUN_ZERIGO_SAMPLE and Fog::credentials[:zerigo_user] and Fog::credentials[:zerigo_password]
#   show_zerigo_dns_usage
# end
