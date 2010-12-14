Shindo.tests('Slicehost::Compute | DNS requests', ['slicehost', 'dns']) do

  @test_domain = 'test-fog.com.'
  @new_zones = []
  @new_records =[]
  
  tests( 'success') do
    
    test('get current zone count') do
      pending if Fog.mocking?

      @org_zone_count= 0
      response = Slicehost[:compute].get_zones()
      if response.status == 200
        zones = response.body['zones']
        @org_zone_count = zones.count
      end
      
      response.status == 200
    end

    test('create zone - simple') do
      pending if Fog.mocking?

      response = Slicehost[:compute].create_zone(@test_domain)
      if response.status == 201
        zone_id = response.body['id']
        @new_zones << zone_id
      end
      
      response.status == 201
    end

    test('create zone - set all parameters') do
      pending if Fog.mocking?

      options = { :ttl => 1800, :active => 'N' }
      domain= 'sub.' + @test_domain
      response = Slicehost[:compute].create_zone( domain, options)
      if response.status == 201
        @zone_id = response.body['id']
        @new_zones << @zone_id
      end
      
      response.status == 201
    end

    test("get zone #{@zone_id} - check all parameters") do
      pending if Fog.mocking?

      result= false
      
      domain= 'sub.' + @test_domain
      response = Slicehost[:compute].get_zone( @zone_id)
      if response.status == 200
        zone = response.body
        if (zone['origin'] == 'sub.' + @test_domain) and (zone['ttl'] == 1800) and
          (zone['active'] == 'N') 
          result= true;
        end
      end
      
      result
    end

    test('get zones - make sure total count is correct') do
      pending if Fog.mocking?

      result= false
      
      response = Slicehost[:compute].get_zones()
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
      
      response = Slicehost[:compute].get_zones()
      if response.status == 200
        zones = response.body['zones']
        zones.each { |zone|
          if zone['id'] == @new_zones[1]
             if (zone['origin'] == 'sub.' + @test_domain) and (zone['ttl'] == 1800) and
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

      domain= 'sub.' + @test_domain
      zone_id= @new_zones[1]
      response = Slicehost[:compute].create_record( 'A', zone_id, domain, '1.2.3.4')
      if response.status == 201
        record_id = response.body['id']
        @new_records << record_id
      end
      
      response.status == 201
    end

    test('create record - A record - all parameters set') do
      pending if Fog.mocking?

      domain= 'sub2.' + @test_domain
      zone_id= @new_zones[1]
      options = { :ttl => 3600, :active => 'N'}
      response = Slicehost[:compute].create_record( 'A', zone_id, domain, '1.2.3.4', options)
      if response.status == 201
        record_id = response.body['id']
        @new_records << record_id
      end
      
      response.status == 201
    end

    test('create record - CNAME record') do
      pending if Fog.mocking?

      domain= 'sub.' + @test_domain
      zone_id= @new_zones[1]
      response = Slicehost[:compute].create_record( 'CNAME', zone_id, 'www', domain)
      if response.status == 201
        record_id = response.body['id']
        @new_records << record_id
      end
      
      response.status == 201
    end

    test('create record - NS record') do
      pending if Fog.mocking?

      domain= 'sub.' + @test_domain
      ns_domain = 'ns.' + @test_domain
      zone_id= @new_zones[1]
      options = { :ttl => 3600, :active => 'N'}
      response = Slicehost[:compute].create_record( 'NS', zone_id, domain, ns_domain, options)
      if response.status == 201
        record_id = response.body['id']
        @new_records << record_id
      end
      
      response.status == 201
    end

    test('create record - MX record') do
      pending if Fog.mocking?

      domain= 'sub.' + @test_domain
      mail_domain = 'mail.' + @test_domain
      zone_id= @new_zones[1]
      options = { :ttl => 3600, :active => 'N', :aux => '10'}
      response = Slicehost[:compute].create_record( 'MX', zone_id, domain, mail_domain, options)
      if response.status == 201
        @record_id = response.body['id']
        @new_records << @record_id
      end
      
      response.status == 201
    end

    test("get record #{@record_id} - verify all parameters") do
      pending if Fog.mocking?

      result= false
      
      response = Slicehost[:compute].get_record(@record_id)
      if response.status == 200
        domain= 'sub.' + @test_domain
        mail_domain = 'mail.' + @test_domain
        record = response.body['records'][0]
        if (record['record-type'] == 'MX') and (record['name'] == domain) and
          (record['data'] == mail_domain) and (record['ttl'] == 3600) and (record['active'] == 'N') and
          (record['aux'] == "10")
          result= true
        end
      end
              
      result
    end
    
    test('get records - verify all parameters for one record') do
      pending if Fog.mocking?

      result= false
      
      response = Slicehost[:compute].get_records()
      if response.status == 200
        records = response.body['records']
        
        #find mx record
        records.each {|record|
          if record['record-type'] == 'MX'

            domain= 'sub.' + @test_domain
            mail_domain = 'mail.' + @test_domain
            if (record['record-type'] == 'MX') and (record['name'] == domain) and
              (record['data'] == mail_domain) and (record['ttl'] == 3600) and (record['active'] == 'N') and
              (record['aux'] == "10")
              result= true
              break
            end

          end
        }
      end
              
      result
    end
    
    test("delete #{@new_records.count} records created") do
      pending if Fog.mocking?

      result= true
      @new_records.each { |record_id|
        response = Slicehost[:compute].delete_record( record_id)
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
        response = Slicehost[:compute].delete_zone( zone_id)
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
