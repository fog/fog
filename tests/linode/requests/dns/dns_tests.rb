Shindo.tests('Fog::DNS[:linode] | DNS requests', ['linode', 'dns']) do

  @domain = ''
  @new_zones = []
  @new_records =[]

  tests( 'success') do

    test('get current zone count') do
      pending if Fog.mocking?

      @org_zone_count= 0
      response = Fog::DNS[:linode].domain_list()
      if response.status == 200
        zones = response.body['DATA']
        @org_zone_count = zones.count
      end
      
      response.status == 200
    end

    test('create zone - simple') do
      pending if Fog.mocking?

      type = 'master'
      domain= generate_unique_domain
      options = { :SOA_email => "netops@#{domain}", :description => "Sample-Domain Inc", :status => 0}
      response = Fog::DNS[:linode].domain_create( domain, type, options)
      if response.status == 200
        @master_zone_id = response.body['DATA']['DomainID']
        @new_zones << @master_zone_id
      end
      
      response.status == 200
    end

    test('create zone - set all parameters') do
      pending if Fog.mocking?

      type = 'slave'
      @domain= generate_unique_domain
      options = { :SOA_email => "netops@#{@domain}", :refresh_sec => 14400, :retry_sec => 3600, 
                  :expire_sec => 604800, :ttl_sec => 28800, :status => 0, :master_ips => '1.2.3.4;2.3.4.5' }
      response = Fog::DNS[:linode].domain_create( @domain, type, options)
      if response.status == 200
        @slave_zone_id = response.body['DATA']['DomainID']
        @new_zones << @slave_zone_id
      end
  
      response.status == 200
    end

    test("get zone #{@slave_zone_id} - check all parameters for #{@domain}") do
      pending if Fog.mocking?

      result= false
      
      response = Fog::DNS[:linode].domain_list( @slave_zone_id)
      if response.status == 200
        zones = response.body['DATA']
        num_zones = zones.count
        if num_zones == 1
          zone= zones[0]
          if (zone['SOA_EMAIL'] == "netops@#{@domain}") and (zone['REFRESH_SEC'] == 14400) and
            (zone['RETRY_SEC'] == 3600) and (zone['EXPIRE_SEC'] == 604800) and (zone['TTL_SEC'] == 28800) and
            (zone['STATUS'] == 0) and (zone['DOMAIN'] == @domain) and (zone['TYPE'] == 'slave') 
            (zone['MASTER_IPS'] == '1.2.3.4;2.3.4.5')
            result= true
          end          
        end
      end
      
      result
    end

    test("update zone #{@slave_zone_id}- update TTL parameter") do
      pending if Fog.mocking?

      result= false
      
      options = { :ttl_sec => 14400 }
      response = Fog::DNS[:linode].domain_update( @slave_zone_id, options)
      if response.status == 200
        result= true
      end
  
      result
    end

    test("get zone #{@slave_zone_id} - check TTL parameters") do
      pending if Fog.mocking?

      result= false
      
      response = Fog::DNS[:linode].domain_list( @slave_zone_id)
      if response.status == 200
        zones = response.body['DATA']
        num_zones = zones.count
        if num_zones == 1
          zone= zones[0]
          if (zone['TTL_SEC'] == 14400)
            result= true
          end          
        end
      end
      
      result
    end

    test('create record - simple A record') do
      pending if Fog.mocking?

      host= 'www.' + @domain
      options = { :name => host, :target => '4.5.6.7', :ttl_sec => 3600 }
      response = Fog::DNS[:linode].domain_resource_create( @master_zone_id, 'A', options)
      if response.status == 200
        record_id = response.body['DATA']['ResourceID']
        @new_records << record_id
      end
      
      response.status == 200
    end

    test('create record - CNAME record') do
      pending if Fog.mocking?

      host= 'mail'
      options = { :name => host, :target => 'www.' + @domain }
      response = Fog::DNS[:linode].domain_resource_create( @master_zone_id, 'CNAME', options)
      if response.status == 200
        record_id = response.body['DATA']['ResourceID']
        @new_records << record_id
      end
      
      response.status == 200
    end

    test('create record - NS record') do
      pending if Fog.mocking?

      options = { :name => @domain, :target => 'ns.' + @domain}
      response = Fog::DNS[:linode].domain_resource_create( @master_zone_id, 'NS', options)
      if response.status == 200
        record_id = response.body['DATA']['ResourceID']
        @new_records << record_id
      end
      
      response.status == 200
    end

    test('create record - MX record') do
      pending if Fog.mocking?

      options = { :target => 'mail.' + @domain, :ttl_sec => 7200, :priority => 5 }
      response = Fog::DNS[:linode].domain_resource_create( @master_zone_id, 'MX', options)
      if response.status == 200
        @record_id = response.body['DATA']['ResourceID']
        @new_records << @record_id
      end
      
      response.status == 200
    end

    test("get record #{@record_id} - verify all parameters") do
      pending if Fog.mocking?

      result= false
      
      domain= 'mail.' + @domain
      response = Fog::DNS[:linode].domain_resource_list(@master_zone_id, @record_id)
      if response.status == 200

        records= response.body['DATA']
        if records.count == 1
          record = records[0]
          if (record['TYPE'] == 'MX') and (record['PRIORITY'] == 5) and (record['TTL_SEC'] == 7200) and
            (record['TARGET'] == domain)
            result= true
          end
        end
        
      end
              
      result
    end

    test("update record #{@record_id} - change target") do 
      pending if Fog.mocking?

      options = { :target => 'mail2.' + @domain }
      response = Fog::DNS[:linode].domain_resource_update( @master_zone_id, @record_id, options)

      response.status == 200
    end

    test("get record #{@record_id} - verify target changed") do
      pending if Fog.mocking?

      result= false
      
      domain= 'mail2.' + @domain
      response = Fog::DNS[:linode].domain_resource_list(@master_zone_id, @record_id)
      if response.status == 200

        records= response.body['DATA']
        if records.count == 1
          record = records[0]
          if record['TARGET'] == domain
            result= true
          end
        end
        
      end
              
      result

    end
    
    test("delete #{@new_records.count} records created") do
      pending if Fog.mocking?

      result= true
      @new_records.each { |record_id|
        response = Fog::DNS[:linode].domain_resource_delete( @master_zone_id, record_id)
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
        response = Fog::DNS[:linode].domain_delete( zone_id)
        if response.status != 200
            result= false;
        end
      }
      result
    end

  end
  
  tests( 'failure') do
  end
    
end
