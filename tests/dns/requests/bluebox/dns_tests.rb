Shindo.tests('Bluebox::dns | DNS requests', ['bluebox', 'dns']) do

  @domain = ''
  @new_zones = []
  @new_records =[]

  def generate_unique_domain(with_trailing_dot = false)
    #get time (with 1/100th of sec accuracy)
    #want unique domain name and if provider is fast, this can be called more than once per second
    time= (Time.now.to_f * 100).to_i
    domain = 'test-' + time.to_s + '.com'
    if with_trailing_dot
      domain+= '.'
    end

    domain
  end

  tests( 'success') do

    test('get current zone count') do
      pending if Fog.mocking?

      @org_zone_count= 0
      response = Bluebox[:dns].get_zones()
      if response.status == 200
        zones = response.body['zones']
        @org_zone_count = zones.count
      end

      response.status == 200
    end

    test('create zone - simple') do
      pending if Fog.mocking?

      domain = generate_unique_domain
      response = Bluebox[:dns].create_zone(:name => domain, :ttl => 360)
      if response.status == 202
        zone_id = response.body['id']
        @new_zones << zone_id
      end

      response.status == 202
    end

    test('create zone - set all parameters') do
      pending if Fog.mocking?

      options = { :ttl => 60, :retry => 3600, :refresh => 1800, :minimum => 30 }
      @domain= generate_unique_domain
      response = Bluebox[:dns].create_zone(options.merge(:name => @domain))
      if response.status == 202
        @zone_id = response.body['id']
        @new_zones << @zone_id
      end

      response.status == 202
    end

    test("get zone #{@zone_id} - check all parameters for #{@domain}") do
      pending if Fog.mocking?

      result = false

      response = Bluebox[:dns].get_zone(@zone_id)
      if response.status == 200
        zone = response.body
        if (zone['name'] == @domain) and (zone['ttl'] == 60)
          result = true
        end
      end

      result
    end

    test('get zones - make sure total count is correct') do
      pending if Fog.mocking?

      result = false

      response = Bluebox[:dns].get_zones()
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

      response = Bluebox[:dns].get_zones()
      if response.status == 200
        zones = response.body['zones']
        zones.each { |zone|
          if zone['id'] == @new_zones[1]
            options = { :ttl => 60, :retry => 3600, :refresh => 1800, :minimum => 30 }
             if (zone['name'] == @domain) and (zone['ttl'] == 60) and (zone['retry'] == 3600) and (zone['refresh'] == 1800) and (zone['minimum'] == 30)
               result = true;
             end
          end
        }
        if (@org_zone_count+2) == zones.count
          result = true;
        end
      end

      result
    end

    test('create record - simple A record') do
      pending if Fog.mocking?

      host= 'www.' + @domain
      zone_id= @new_zones[1]
      response = Bluebox[:dns].create_record(zone_id, 'A', host, '1.2.3.4')
      if response.status == 202
        record_id = response.body['id']
        @new_records << record_id
      end

      response.status == 202
    end

    test('create record - A record - all parameters set') do
      pending if Fog.mocking?

      host= 'ftp.' + @domain
      zone_id= @new_zones[1]
      response = Bluebox[:dns].create_record( zone_id, 'A', host, '1.2.3.4')
      if response.status == 202
        record_id = response.body['id']
        @new_records << record_id
      end

      response.status == 202
    end

    test('create record - CNAME record') do
      pending if Fog.mocking?

      zone_id= @new_zones[1]
      response = Bluebox[:dns].create_record( zone_id, 'CNAME', 'mail', @domain)
      if response.status == 202
        record_id = response.body['id']
        @new_records << record_id
      end

      response.status == 202
    end

    test('create record - NS record') do
      pending if Fog.mocking?

      ns_domain = 'ns.' + @domain
      zone_id= @new_zones[1]
      response = Bluebox[:dns].create_record( zone_id, 'NS', @domain, ns_domain)
      if response.status == 202
        record_id = response.body['id']
        @new_records << record_id
      end

      response.status == 202
    end

    test('create record - MX record') do
      pending if Fog.mocking?

      mail_domain = 'mail.' + @domain
      zone_id= @new_zones[1]
      response = Bluebox[:dns].create_record(  zone_id, 'MX', @domain, mail_domain, :priority => 10)
      if response.status == 202
        @record_id = response.body['id']
        @new_records << @record_id
      end

      response.status == 202
    end

    test("get record #{@record_id} - verify all parameters") do
      pending if Fog.mocking?

      result= false

      response = Bluebox[:dns].get_record(@new_zones[1], @record_id)
      if response.status == 200
        mail_domain = 'mail.' + @domain + "."
        record = response.body
        if (record['type'] == 'MX') and (record['name'] == @domain) and (record['content'] == mail_domain) and (record['priority'] == '10')
          result= true
        end
      end

      result
    end

    test('get records - verify all parameters for one record') do
      pending if Fog.mocking?

      result= false

      response = Bluebox[:dns].get_records(@new_zones[1])
      if response.status == 200
        records = response.body['records']

        #find mx record
        records.each {|record|
          if record['type'] == 'MX'

            mail_domain = 'mail.' + @domain + "."
            if (record['type'] == 'MX') and (record['name'] == @domain) and (record['content'] == mail_domain) and (record['priority'] == '10')
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
        response = Bluebox[:dns].delete_record(@new_zones[1], record_id)
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
        response = Bluebox[:dns].delete_zone( zone_id)
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
