Shindo.tests('Fog::DNS[:slicehost] | DNS requests', ['slicehost', 'dns']) do

  @domain = ''
  @new_zones = []
  @new_records =[]

  tests( 'success') do
    
    test('get current zone count') do
      pending if Fog.mocking?

      @org_zone_count= 0
      response = Fog::DNS[:slicehost].get_zones()
      if response.status == 200
        zones = response.body['zones']
        @org_zone_count = zones.count
      end
      
      response.status == 200
    end

    test('create zone - simple') do
      pending if Fog.mocking?

      domain = generate_unique_domain( true)
      response = Fog::DNS[:slicehost].create_zone(domain)
      if response.status == 201
        zone_id = response.body['id']
        @new_zones << zone_id
      end
      
      response.status == 201
    end

    test('create zone - set all parameters') do
      pending if Fog.mocking?

      options = { :ttl => 1800, :active => 'N' }
      @domain= generate_unique_domain( true)
      response = Fog::DNS[:slicehost].create_zone( @domain, options)
      if response.status == 201
        @zone_id = response.body['id']
        @new_zones << @zone_id
      end
      
      response.status == 201
    end

    test("get zone #{@zone_id} - check all parameters for #{@domain}") do
      pending if Fog.mocking?

      result= false
      
      response = Fog::DNS[:slicehost].get_zone( @zone_id)
      if response.status == 200
        zone = response.body
        if (zone['origin'] == @domain) and (zone['ttl'] == 1800) and
          (zone['active'] == 'N') 
          result= true;
        end
      end
      
      result
    end

    test('get zones - make sure total count is correct') do
      pending if Fog.mocking?

      result= false
      
      response = Fog::DNS[:slicehost].get_zones()
      if response.status == 200
        zones = response.body['zones']
        if (@org_zone_count+2) == zones.count
          result= true;
        end
      end
      
      result
    end

    test('get zones - check all parameters for a zone') do
      pending if Fog.mocking?

      result= false
      
      response = Fog::DNS[:slicehost].get_zones()
      if response.status == 200
        zones = response.body['zones']
        zones.each { |zone|
          if zone['id'] == @new_zones[1]
             if (zone['origin'] == 'sub.' + @domain) and (zone['ttl'] == 1800) and
               (zone['active'] == 'N') 
               result= true;
             end
          end
        }
        if (@org_zone_count+2) == zones.count
          result= true;
        end
      end
      
      result
    end

    test('create record - simple A record') do
      pending if Fog.mocking?

      host= 'www.' + @domain
      zone_id= @new_zones[1]
      response = Fog::DNS[:slicehost].create_record( 'A', zone_id, host, '1.2.3.4')
      if response.status == 201
        record_id = response.body['id']
        @new_records << record_id
      end
      
      response.status == 201
    end

    test('create record - A record - all parameters set') do
      pending if Fog.mocking?

      host= 'ftp.' + @domain
      zone_id= @new_zones[1]
      options = { :ttl => 3600, :active => 'N'}
      response = Fog::DNS[:slicehost].create_record( 'A', zone_id, host, '1.2.3.4', options)
      if response.status == 201
        record_id = response.body['id']
        @new_records << record_id
      end
      
      response.status == 201
    end

    test('create record - CNAME record') do
      pending if Fog.mocking?

      zone_id= @new_zones[1]
      response = Fog::DNS[:slicehost].create_record( 'CNAME', zone_id, 'mail', @domain)
      if response.status == 201
        record_id = response.body['id']
        @new_records << record_id
      end
      
      response.status == 201
    end

    test('create record - NS record') do
      pending if Fog.mocking?

      ns_domain = 'ns.' + @domain
      zone_id= @new_zones[1]
      options = { :ttl => 3600, :active => 'N'}
      response = Fog::DNS[:slicehost].create_record( 'NS', zone_id, @domain, ns_domain, options)
      if response.status == 201
        record_id = response.body['id']
        @new_records << record_id
      end
      
      response.status == 201
    end

    test('create record - MX record') do
      pending if Fog.mocking?

      mail_domain = 'mail.' + @domain
      zone_id= @new_zones[1]
      options = { :ttl => 3600, :active => 'N', :aux => '10'}
      response = Fog::DNS[:slicehost].create_record( 'MX', zone_id, @domain, mail_domain, options)
      if response.status == 201
        @record_id = response.body['id']
        @new_records << @record_id
      end
      
      response.status == 201
    end

    test("get record #{@record_id} - verify all parameters") do
      pending if Fog.mocking?

      result= false
      
      response = Fog::DNS[:slicehost].get_record(@record_id)
      if response.status == 200
        mail_domain = 'mail.' + @domain
        record = response.body
        if (record['record_type'] == 'MX') and (record['name'] == @domain) and
          (record['value'] == mail_domain) and (record['ttl'] == 3600) and (record['active'] == 'N') and
          (record['aux'] == "10")
          result = true
        end
      end
              
      result
    end
    
    test('get records - verify all parameters for one record') do
      pending if Fog.mocking?

      result = false
      
      response = Fog::DNS[:slicehost].get_records()
      if response.status == 200
        records = response.body['records']
        
        #find mx record
        records.each {|record|
          if (record['record_type'] == 'MX') and (record['name'] == @domain)

            mail_domain = 'mail.' + @domain
            if (record['record_type'] == 'MX') and (record['name'] == @domain) and
              (record['value'] == mail_domain) and (record['ttl'] == 3600) and (record['active'] == 'N') and
              (record['aux'] == "10")
              result = true
            end
            break
          end
        }
      end
              
      result
    end

    test('update record - verify all parameters for one record') do
      pending if Fog.mocking?

      result = false

      specific_record = nil

      response = Fog::DNS[:slicehost].get_records()
      if response.status == 200
        records = response.body['records']

        #find mx record
        records.each {|record|
          if (record['record_type'] == 'MX') and (record['name'] == @domain)
            specific_record = record
            break
          end
        }
      end

      if (specific_record)  #Try to change the TTL for this MX record if we've successfully created it.
        response = Fog::DNS[:slicehost].update_record(specific_record['id'], specific_record['record_type'], specific_record['zone_id'],
                                          specific_record['name'], specific_record['value'], {:ttl => 7200, :active => "N", :aux => "10"})

        mail_domain = 'mail.' + @domain

        record = Fog::DNS[:slicehost].get_record(specific_record['id']).body

        if (record['record_type'] == 'MX') and (record['name'] == @domain) and
              (record['value'] == mail_domain) and (record['ttl'] == 7200) and (record['active'] == 'N') and
              (record['aux'] == "10")
              result = true
        end

      end

      result
    end

    test("newly created zone returns only records which we added to it, not other records already in account") do
      pending if Fog.mocking?

      @new_zone = Fog::DNS[:slicehost].zones.get(@zone_id)
      
      records = @new_zone.records
      records.length == @new_records.length
    end
    
    test("delete #{@new_records.count} records created") do
      pending if Fog.mocking?

      result= true
      @new_records.each { |record_id|
        response = Fog::DNS[:slicehost].delete_record( record_id)
        if response.status != 200
            result= false;
        end
      }
      result
    end
    
    test("delete #{@new_zones.count} zones created") do
      pending if Fog.mocking?

      result= true
      
      @new_zones.each { |zone_id|
        response = Fog::DNS[:slicehost].delete_zone( zone_id)
        if response.status != 200
            result= false;
        end
      }

      result
    end

  end

  
  tests( 'failure') do
    
    #create a zone with invalid parameters
    #get zonfo info with invalid zone id
    #delete a zone with an invalid zone id
    
    tests('#create_zone') do
    end
    
  end
    
end
