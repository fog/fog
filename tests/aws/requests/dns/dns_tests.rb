Shindo.tests('Fog::DNS[:aws] | DNS requests', ['aws', 'dns']) do

  @org_zone_count = 0
  @zone_id = ''
  @change_id = ''
  @new_records =[]
 
  # NOTE: can't use generate_unique_domain() as we do in other DNS provider
  #       test suites as AWS charges $1/mth for each domain, even if it exists 
  #       on AWS for only the time that this test suite runs!!
  #       http://aws.amazon.com/route53/pricing/
  @test_domain = 'test-343246324434.com'
  
  tests( 'success') do

    test('see if test domain already exists') do
      pending if Fog.mocking?
      
      @zone_id = nil
      
      response = Fog::DNS[:aws].list_hosted_zones()
      if response.status == 200
        @hosted_zones = response.body['HostedZones']
      end

      #go through zones for this account
      @hosted_zones.each { |zone|
        domain = zone['Name']
        if domain.chomp == @test_domain
          @zone_id = zone['Id']
        end
      }
      
      @zone_id.nil?
    end
      
    test('get current zone count') do
      pending if Fog.mocking?

      @org_zone_count= 0
      response = Fog::DNS[:aws].list_hosted_zones()
      if response.status == 200
        @hosted_zones = response.body['HostedZones']
        @org_zone_count = @hosted_zones.count
      end

      response.status == 200
    end

    test('create simple zone') {
      pending if Fog.mocking?

      result = false
      
      response = Fog::DNS[:aws].create_hosted_zone( @test_domain)
      if response.status == 201

        zone= response.body['HostedZone']
        change_info = response.body['ChangeInfo']
        ns_servers = response.body['NameServers']

        if (zone and change_info and ns_servers)

          @zone_id = zone['Id']
          caller_ref = zone['CallerReference']
          @change_id = change_info['Id']
          status = change_info['Status']
          ns_srv_count = ns_servers.count
          
          if (@zone_id.length > 0) and (caller_ref.length > 0) and (@change_id.length > 0) and
             (status.length > 0) and (ns_srv_count > 0)
            result = true
          end
        end
      end

      result
    }
    
    test("get status of change #{@change_id}") {
      pending if Fog.mocking?

      result = false
      response = Fog::DNS[:aws].get_change(@change_id)
      if response.status == 200
        status = response.body['Status']
        if (status == 'PENDING') or (status == 'INSYNC')
          result= true
        end
      end
      
      result
    }
   
    test("get info on hosted zone #{@zone_id}") {
      pending if Fog.mocking?

      result = false
      
      response = Fog::DNS[:aws].get_hosted_zone( @zone_id)
      if response.status == 200
        zone = response.body['HostedZone']
        zone_id = zone['Id']
        name = zone['Name']
        caller_ref = zone['CallerReference']
        ns_servers = response.body['NameServers']

        # AWS returns domain with a dot at end - so when compare, remove dot
        
        if (zone_id == @zone_id) and (name.chop == @test_domain) and (caller_ref.length > 0) and
           (ns_servers.count > 0)
           result = true
        end
      end
      
      result
    }
    
    test('list zones') do
      pending if Fog.mocking?

      result = false
      
      response = Fog::DNS[:aws].list_hosted_zones()
      if response.status == 200
        
        zones= response.body['HostedZones']
        if (zones.count > 0)
          zone= zones[0]
          zone_id = zone['Id']
          zone_name= zone['Name']
          caller_ref = zone['CallerReference']
        end
        max_items = response.body['MaxItems']
                  
        if (zone_id.length > 0) and (zone_name.length > 0) and (caller_ref.length > 0) and 
           (max_items > 0)
          result = true
        end      
      end

      result
    end
    
    test("add a A resource record") {
      pending if Fog.mocking?

      result = false
      
      # create an A resource record
      host = 'www.' + @test_domain
      ip_addrs = ['1.2.3.4']
      resource_record = { :name => host, :type => 'A', :ttl => 3600, :resource_records => ip_addrs }
      resource_record_set = resource_record.merge( :action => 'CREATE')
  
      change_batch = []
      change_batch << resource_record_set
      options = { :comment => 'add A record to domain'}             
      response = Fog::DNS[:aws].change_resource_record_sets( @zone_id, change_batch, options)
      if response.status == 200
        change_id = response.body['Id']
        status = response.body['Status']
        @new_records << resource_record
      end
      
      response.status == 200
    }

    test("add a CNAME resource record") {
      pending if Fog.mocking?

      result = false
      
      # create a CNAME resource record
      host = 'mail.' + @test_domain
      value = ['www.' + @test_domain]
      resource_record = { :name => host, :type => 'CNAME', :ttl => 3600, :resource_records => value }
      resource_record_set = resource_record.merge( :action => 'CREATE')
  
      change_batch = []
      change_batch << resource_record_set
      options = { :comment => 'add CNAME record to domain'}             
      response = Fog::DNS[:aws].change_resource_record_sets( @zone_id, change_batch, options)
      if response.status == 200
        change_id = response.body['Id']
        status = response.body['Status']
        @new_records << resource_record
      end
      
      response.status == 200
    }
    
    test("add a MX resource record") {
      pending if Fog.mocking?

      result = false
      
      # create a MX resource record
      host = @test_domain
      value = ['7 mail.' + @test_domain]
      resource_record = { :name => host, :type => 'MX', :ttl => 3600, :resource_records => value }
      resource_record_set = resource_record.merge( :action => 'CREATE')
  
      change_batch = []
      change_batch << resource_record_set
      options = { :comment => 'add MX record to domain'}             
      response = Fog::DNS[:aws].change_resource_record_sets( @zone_id, change_batch, options)
      if response.status == 200
        change_id = response.body['Id']
        status = response.body['Status']
        @new_records << resource_record
      end
      
      response.status == 200
    }

    test("list resource records")  {
      pending if Fog.mocking?

      # get resource records for zone
      response = Fog::DNS[:aws].list_resource_record_sets( @zone_id)
      if response.status == 200
        record_sets= response.body['ResourceRecordSets']
        num_records= record_sets.count
      end

      response.status == 200
    }

    test("delete #{@new_records.count} resource records") {
      pending if Fog.mocking?

      result = true
      
      change_batch = []
      @new_records.each { |record|      
        resource_record_set = record.merge( :action => 'DELETE')
        change_batch << resource_record_set
      }
      options = { :comment => 'remove records from domain'}             
      response = Fog::DNS[:aws].change_resource_record_sets( @zone_id, change_batch, options)
      if response.status != 200
        result = false
        break
      end

      result
    }
    
    test("delete hosted zone #{@zone_id}") {
      pending if Fog.mocking?

      response = Fog::DNS[:aws].delete_hosted_zone( @zone_id)

      response.status == 200
    }
  
  end


  tests( 'failure') do
    tests('create hosted zone using invalid domain name').raises(Excon::Errors::BadRequest) do
      pending if Fog.mocking?
      response = Fog::DNS[:aws].create_hosted_zone('invalid-domain')
    end
    
    tests('get hosted zone using invalid ID').raises(Excon::Errors::Forbidden) do
      pending if Fog.mocking?
      zone_id = 'dummy-id'
      response = Fog::DNS[:aws].get_hosted_zone(zone_id)
    end
  
  end

  
end
