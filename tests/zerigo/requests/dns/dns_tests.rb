Shindo.tests('Fog::DNS[:zerigo] | DNS requests', ['zerigo', 'dns']) do

  # tests assume have a free acccount - ie need to limit # of zones to max of 3
  MAX_ZONE_COUNT = 3
  @domain = ''
  @org_zone_count = 0
  @new_zones = []
  @new_records =[]

  def generate_unique_domain( with_trailing_dot = false)
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
      response = Fog::DNS[:zerigo].count_zones()
      if response.status == 200
        @org_zone_count = response.body['count']
      end

      response.status == 200
    end

    test('create zone - simple') do
      pending if Fog.mocking?

      options = { :nx_ttl => 1800 }
      domain = generate_unique_domain
      response = Fog::DNS[:zerigo].create_zone( domain, 3600, 'pri_sec', options)
      if response.status == 201
        zone_id = response.body['id']
        #worked so can now delete
        response = Fog::DNS[:zerigo].delete_zone( zone_id)
      end

      response.status == 200
    end

    test('create zone - set zerigo as slave') do
      pending if Fog.mocking?

      options = { :active => 'N', :ns1=> '2.3.4.5' }
      domain= generate_unique_domain
      response = Fog::DNS[:zerigo].create_zone( domain, 14400, 'sec', options )
      if response.status == 201
        zone_id = response.body['id']
        #worked so can now delete
        response = Fog::DNS[:zerigo].delete_zone( zone_id)
      end

      response.status == 200
    end

    test('create zone - set zerigo as master') do
      pending if Fog.mocking?

      domain= generate_unique_domain
      options = { :active => 'N', :slave_nameservers=> "ns1.#{domain},ns2.#{domain}" }
      response = Fog::DNS[:zerigo].create_zone( domain, 14400, 'pri', options )
      if response.status == 201
        zone_id = response.body['id']
        #worked so can now delete
        response = Fog::DNS[:zerigo].delete_zone( zone_id)
      end

      response.status == 200
    end

    test('create zone - set all parameters') do
      pending if Fog.mocking?

      @domain = generate_unique_domain
      options = { :nx_ttl => 1800, :active => 'N', :hostmaster => "netops@#{@domain}",
                  :notes => 'for client ABC', :tag_list=> 'sample-tag' }
      response = Fog::DNS[:zerigo].create_zone( @domain, 14400, 'pri', options )
      if response.status == 201
        @zone_id = response.body['id']
        @new_zones << @zone_id
      end

      response.status == 201
    end

    test("get zone #{@zone_id} for #{@domain}- check all parameters") do
      pending if Fog.mocking?

      result= false

      response = Fog::DNS[:zerigo].get_zone( @zone_id)
      if response.status == 200
        zone = response.body
        if (zone['ns-type'] == 'pri') and (zone['tag-list'] == 'sample-tag') and
            (zone['default-ttl'] == 14400) and (zone['nx-ttl'] == 1800) and
            (zone['updated-at'].length > 0) and (zone['created-at'].length > 0) and
            (zone['domain'] == @domain) and (zone['notes'] == 'for client ABC') and
            (zone['id'] == @zone_id)
            result = true
        end

        result
      end
    end

    test("update zone #{@zone_id} - set notes & tags") do
      pending if Fog.mocking?

      options = { :notes => 'for client XYZ', :tag_list=> 'testing-tag' }
      response = Fog::DNS[:zerigo].update_zone( @zone_id, options )

      response.status == 200
    end

    test("get zone #{@zone_id} - check updated parameters") do
      pending if Fog.mocking?

      result= false

      response = Fog::DNS[:zerigo].get_zone( @zone_id)
      if response.status == 200
        zone = response.body
        if (zone['tag-list'] == 'testing-tag') and (zone['notes'] == 'for client XYZ')
            result = true
        end

        result
      end
    end

    test("get zone stats for #{@zone_id}") do
      pending if Fog.mocking?

      result= false

      response = Fog::DNS[:zerigo].get_zone_stats( @zone_id)
      if response.status == 200
        zone = response.body
        if (zone['domain'] == @domain) and (zone['id'] == @zone_id) and
           (zone['period-begin'].length > 0) and (zone['period-end'].length > 0)
          result= true
        end

        result
      end

    end

    test("list zones - make sure total count is #{@org_zone_count+1}") do
      pending if Fog.mocking?

      result= false

      response = Fog::DNS[:zerigo].list_zones()
      if response.status == 200
        zones = response.body['zones']
        if (@org_zone_count+1) == zones.count
          result= true;
        end
      end

      result
    end

    test('list zones with pagination') do
      pending if Fog.mocking?

      result = false

      # make enough zones to paginate
      number_zones_to_create = MAX_ZONE_COUNT-@org_zone_count-1
      number_zones_to_create.times do |i|
        domain = generate_unique_domain
        options = { :nx_ttl => 1800, :active => 'N', :hostmaster => "netops@#{domain}",
                    :notes => 'for client ABC', :tag_list=> "sample-tag-#{i}" }
        response = Fog::DNS[:zerigo].create_zone( domain, 14400, 'pri', options )
        if response.status == 201
          @new_zones << response.body['id']
        else
          return false
        end
      end

      total_zone_count_response = Fog::DNS[:zerigo].list_zones()
      if total_zone_count_response.status == 200
        if number_zones_to_create > 0
          zones_we_should_see = @new_zones.dup
          total_zone_count = total_zone_count_response.headers['X-Query-Count'].to_i
        else
          zones_we_should_see = total_zone_count_response.body['zones'].map {|z| z['id']}
          total_zone_count = zones_we_should_see.count
        end

        total_zone_count.times do |i|
          # zerigo pages are 1-indexed, not 0-indexed
          response = Fog::DNS[:zerigo].list_zones(:per_page => 1, :page => i+1)
          zones = response.body['zones']
          if 1 == zones.count
            zones_we_should_see.delete(zones.first['id'])
          end
        end

        if zones_we_should_see.empty?
          result = true
        end
      end

      result
    end

    test('create record - simple A record') do
      pending if Fog.mocking?

      host= 'www'
      options = { :hostname => host }
      response = Fog::DNS[:zerigo].create_host( @zone_id, 'A', '1.2.3.4', options)
      if response.status == 201
        record_id = response.body['id']
        @new_records << record_id
      end

      response.status == 201
    end

    test('create record - CNAME record') do
      pending if Fog.mocking?

      host = 'mail'
      options = { :hostname => host }
      response = Fog::DNS[:zerigo].create_host( @zone_id, 'CNAME', @domain, options)
      if response.status == 201
        record_id = response.body['id']
        @new_records << record_id
      end

      response.status == 201
    end

    test('create record - NS record') do
      pending if Fog.mocking?

      #note, when use create_host for a NS record, it needs to be a delation
      #rather than a NS record for the main domain (those NS records are setup
      #using the zone methods)
      sub_domain = 'subdomain'        # that we want to delete DNS for
      ns_host = 'ns.' + @domain
      options = { :hostname => sub_domain}
      response = Fog::DNS[:zerigo].create_host( @zone_id, 'NS', ns_host, options)
      if response.status == 201
        record_id = response.body['id']
        @new_records << record_id
      end

      response.status == 201
    end

    test('create record - MX record') do
      pending if Fog.mocking?

      mail_domain = 'mail.' + @domain
      options = { :hostname => @domain, :ttl => 3600, :priority => '3'}
      response = Fog::DNS[:zerigo].create_host( @zone_id, 'MX', mail_domain, options)
      if response.status == 201
        @record_id = response.body['id']
        @new_records << @record_id
      end

      response.status == 201
    end

    test("get host #{@record_id}") do
      pending if Fog.mocking?

      result = false

      response = Fog::DNS[:zerigo].get_host( @record_id)
      if response.status == 200
        host = response.body
        if (host['id'] == @record_id) and (host['host-type'] == 'MX') and
           (host['created-at'].length > 0) and (host['updated-at'].length > 0)
          result = true
        end
      end

      result
    end

    test("update host #{@record_id}") do
      pending if Fog.mocking?

      result = false

      options = { :priority => 7 }
      response = Fog::DNS[:zerigo].update_host( @record_id, options)
      if response.status == 200
        response = Fog::DNS[:zerigo].get_host( @record_id)
        if response.status == 200
          host= response.body
          if (host['priority']  == 7)
            result = true
          end
        end
      end

      result
    end

    test('count host records') do
      pending if Fog.mocking?

      host_count = 0
      response = Fog::DNS[:zerigo].count_hosts( @zone_id)
      if response.status == 200
        host_count = response.body['count']
      end

      host_count == 4
    end

    test("list host records") do
      pending if Fog.mocking?

      result = false

      response = Fog::DNS[:zerigo].list_hosts( @zone_id)
      if response.status == 200
        hosts = response.body["hosts"]
        if (hosts.count == 4)
          hosts.each { |host|
            if (host["id"] > 0) and (host["fqdn"].length > 0) and (host["host-type"].length > 0) and
               (host["created-at"].length > 0) and (host["updated-at"].length > 0)
              result = true
            end
          }
        end
      end

      result
    end

    test("list host records with options") do
      pending if Fog.mocking?

      result = false

      response = Fog::DNS[:zerigo].list_hosts(@zone_id, {:per_page=>2, :page=>1})
      if response.status == 200
        hosts = response.body["hosts"]
        if (hosts.count == 2)
          hosts.each { |host|
            if (host["id"] > 0) and (host["fqdn"].length > 0) and (host["host-type"].length > 0) and
               (host["created-at"].length > 0) and (host["updated-at"].length > 0)
              result = true
            end
          }
        end
      end

      result
    end

    test("find host: mail.#{@domain}") do
      pending if Fog.mocking?

      result = false

      host = 'mail.' + @domain
      response = Fog::DNS[:zerigo].find_hosts( host)
      if response.status == 200
        hosts = response.body['hosts']
        host_count = hosts.count
        if (host_count == 1)
          result = true
        end
      end

      result
    end

    test("find host: mail.#{@domain} - method 2") do
      pending if Fog.mocking?

      result = false

      host = 'mail.' + @domain
      response = Fog::DNS[:zerigo].find_hosts( host, @zone_id)
      if response.status == 200
        hosts = response.body['hosts']
        host_count = hosts.count
        if (host_count == 1)
          result = true
        end
      end

      result
    end

    test("delete #{@new_records.count} records created") do
      pending if Fog.mocking?

      result= true
      @new_records.each { |record_id|
        response = Fog::DNS[:zerigo].delete_host( record_id)
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
        response = Fog::DNS[:zerigo].delete_zone( zone_id)
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
