Shindo.tests('Fog::DNS[:rage4] | DNS requests', ['rage4', 'dns']) do

  @domain = ''
  @domain_id = nil
  @record_id = nil
  @domain_count = 0

  @created_domain_list = []

  tests("success") do

    test("get current domain count") do
      pending if Fog.mocking?

      response = Fog::DNS[:rage4].list_domains()
      if response.status == 200
        @domain_count = response.body.size
      end

      if response.status == 200
        response.body = []
      end

      response.status == 200
    end

    test("create domain") do
      pending if Fog.mocking?

      domain = generate_unique_domain
      response = Fog::DNS[:rage4].create_domain(domain)
      if response.status == 200
        @domain_id = response.body['id']
        @domain = domain
      end

      if response.status == 200 && response.body['id'] != 0
        @created_domain_list << response.body['id']
      end

      response.status == 200 && response.body['error'] == "" &&
      response.body['status'] && !@domain_id.nil?
    end

    test("create_domain_vanity") do
      pending if Fog.mocking?

      domain = generate_unique_domain
      response = Fog::DNS[:rage4].create_domain_vanity(domain, 'foo.com')

      if response.status == 200 && response.body['id'] != 0
        @created_domain_list << response.body['id']
      end

      response.status == 200 && response.body['error'] == "" &&
      response.body['status']
    end

    test("create_reverse_domain_4") do
      pending if Fog.mocking?

      response = Fog::DNS[:rage4].create_reverse_domain_4('192.168.1.1', 29)

      if response.status == 200 && response.body['id'] != 0
        @created_domain_list << response.body['id']
      end

      response.status == 200 && response.body['error'] == "" &&
      response.body['status']
    end

    test("get_domain") do
      pending if Fog.mocking?

      response = Fog::DNS[:rage4].get_domain(@domain_id)

      returns(200) {response.status}
      returns(@domain_id) {response.body['id']}
      returns(@domain) {response.body['name']}
      returns(Fog.credentials[:rage4_email]) {response.body['owner_email']}
      returns(0) {response.body['type']}
      returns(0) {response.body['subnet_mask']}
    end

    test("get_domain_by_name") do
      pending if Fog.mocking?

      response = Fog::DNS[:rage4].get_domain_by_name(@domain)

      returns(200) {response.status}
      returns(@domain_id) {response.body['id']}
      returns(@domain) {response.body['name']}
      returns(Fog.credentials[:rage4_email]) {response.body['owner_email']}
      returns(0) {response.body['type']}
      returns(0) {response.body['subnet_mask']}
    end

    test("update_domain") do
      pending if Fog.mocking?

      response = Fog::DNS[:rage4].update_domain(@domain_id, {:email => 'test@test.com'})

      returns(200) { response.status }
      returns(true) {response.body['status']}
      returns(@domain_id) {response.body['id']}
      returns("") {response.body['error'] }

    end

    test("show_current_usage") do
      pending if Fog.mocking?

      response = Fog::DNS[:rage4].show_current_usage(@domain_id)
      returns(200) { response.status }
      returns([])  { response.body }
    end

    test("show_global_usage") do
      pending if Fog.mocking?

      response = Fog::DNS[:rage4].show_global_usage()
      returns(200) { response.status }
      returns([])  { response.body }
    end

    test("list_record_types") do
      pending if Fog.mocking?

      response = Fog::DNS[:rage4].list_record_types()
      response.body.each do |record_type|
        returns(true) { !record_type['name'].nil? }
        returns(true) { !record_type['value'].nil? }
      end

      returns(200) { response.status }
      returns(Array) { response.body.class }
    end

    test("list_geo_regions") do
      pending if Fog.mocking?

      response = Fog::DNS[:rage4].list_geo_regions()
      response.body.each do |record_type|
        returns(true) { !record_type['name'].nil? }
        returns(true) { !record_type['value'].nil? }
      end

      returns(200) { response.status }
      returns(Array) { response.body.class }
    end

    test("create_record") do
      pending if Fog.mocking?

      name = "www." + @domain
      type = 2 #"A"
      data = "1.2.3.4"
      response = Fog::DNS[:rage4].create_record(@domain_id, name , data, type)

      if response.status == 200
        @record_id = response.body['id']
      end

      response.status == 200 && response.body['error'] == "" &&
      response.body['status'] && !@record_id.nil?
    end

    test("create_record with options") do
      pending if Fog.mocking?

      name = "www." + @domain
      type = 2 #"A"
      data = "1.2.3.5"
      options = { :udplimit => true }
      response = Fog::DNS[:rage4].create_record(@domain_id, name , data, type, options)

      if response.status == 200
        @record_id = response.body['id']
      end

      response.status == 200 && response.body['error'] == "" &&
      response.body['status'] && !@record_id.nil?
    end

    test("update_record") do
      pending if Fog.mocking?

      name = "www." + @domain
      type = 2 #"A"
      data = "4.3.2.1"
      response = Fog::DNS[:rage4].update_record(@record_id, name, data, type)

      returns(@record_id) { response.body['id'] }

      response.status == 200 && response.body['error'] == "" &&
      response.body['status']
    end

    test("update_record with options") do
      pending if Fog.mocking?

      name = "www." + @domain
      type = 2 #"A"
      data = "4.3.2.1"
      options = { :udplimit => true }
      response = Fog::DNS[:rage4].update_record(@record_id, name, data, type, options)

      returns(@record_id) { response.body['id'] }

      response.status == 200 && response.body['error'] == "" &&
      response.body['status']
    end

    test("list_records") do
      pending if Fog.mocking?

      response = Fog::DNS[:rage4].list_records(@domain_id)
      # returns nameserver records as well, will only verify
      # the record we have tracked

      response.body.each do |record|
        if record['id'] == @record_id
          returns(@record_id)       { record['id'] }
          returns("www." + @domain) { record['name'] }
          returns("A") { record['type'] }
          returns(3600) { record['ttl'] }
          returns(nil) { record['priority'] }
          returns(@domain_id) { record['domain_id'] }
          returns(0) { record['geo_region_id'] }
          returns(false) { record['failover_enabled'] }
          returns(nil) { record['failover_content'] }
          returns(true) { record['is_active'] }
          returns(false) { record['geo_lock'] }
        end
      end

      response.status == 200
    end

    test("delete_record") do
      pending if Fog.mocking?

      response = Fog::DNS[:rage4].delete_record(@record_id)
      returns(@record_id) { response.body['id'] }

      response.status == 200 && response.body['error'] == "" &&
      response.body['status']
    end

    test("delete_domain") do
      pending if Fog.mocking?

      response = nil
      @created_domain_list.each do |domain_id|
        response = Fog::DNS[:rage4].delete_domain(domain_id)

        returns(true) {response.body['status']}
        returns(domain_id) {response.body['id']}
        returns("") {response.body['error'] }
      end

      response.status == 200
    end

  end

  tests( 'failure') do
  end

end
