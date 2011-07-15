Shindo.tests('Fog::DNS[:dnsmadeeasy] | DNS requests', ['dnsmadeeasy', 'dns']) do

  @domain = ''
  @domain_count = 0

  tests("success") do

    test("get current domain count") do
      pending if Fog.mocking?

      response = Fog::DNS[:dnsmadeeasy].list_domains()
      if response.status == 200
        @domain_count = response.body['list'].size
      end

      response.status == 200
    end

    test("create domain") do
      pending if Fog.mocking?

      domain = generate_unique_domain
      response = Fog::DNS[:dnsmadeeasy].create_domain(domain)
      if response.status == 201
        @domain = response.body
      end

      response.status == 201
    end

    test("get domain by name") do
      pending if Fog.mocking?

      response = Fog::DNS[:dnsmadeeasy].get_domain(@domain["name"])
      response.status == 200
    end

    test("create an A resource record") do
      pending if Fog.mocking?

      domain = @domain["name"]
      name = "www"
      type = "A"
      data = "1.2.3.4"
      response = Fog::DNS[:dnsmadeeasy].create_record(domain, name, type, data)

      if response.status == 201
        @record = response.body
      end

      response.status == 201

    end

    test("create a MX record") do
      pending if Fog.mocking?

      domain = @domain["name"]
      name = ""
      type = "MX"
      data = "10 mail.#{domain}"
      options = { :ttl => 60 }
      response = Fog::DNS[:dnsmadeeasy].create_record(domain, name, type, data, options)

      response.status == 201
    end

    test("update a record") do
      pending if Fog.mocking?

      domain = @domain["name"]
      record_id = @record["id"]
      options = {:name => '', :type => 'A', :data => "2.3.4.5", :ttl => 600}

      response = Fog::DNS[:dnsmadeeasy].update_record(domain, record_id, options)

      response.status == 200
    end

    test("get record - check ip/ttl") do
      pending if Fog.mocking?

      response = Fog::DNS[:dnsmadeeasy].get_record(@domain["name"], @record['id'])
      record = response.body
      result = false

      if response.status == 200 && record['data'] == '2.3.4.5' && record['ttl'] == 600
        result = true
      end

      result
    end

    test("list records") do
      pending if Fog.mocking?

      response = Fog::DNS[:dnsmadeeasy].list_records(@domain["name"])

      if response.status == 200
        @records = response.body
      end

      (response.status == 200) and (response.body.size == 2)
    end

    test("delete records") do
      pending if Fog.mocking?
      domain = @domain["name"]

      result = true
      @records.each do |record|
        response = Fog::DNS[:dnsmadeeasy].delete_record(domain, record["id"])
        if(response.status != 200)
          result = false
          break
        end
      end

      result
    end

    test("delete domain") do
      pending if Fog.mocking?

      puts "DNS Made Easy - Sleeping for 10 seconds, otherwise test fails because DNS Made Easy queues requests, it still might fail if DNS Made Easy is busy! MOCK IT!"
      puts "THIS MOST LIKELY WILL FAIL ON LIVE because it can take while for DNS Made Easy to create a domain/zone, changing the host to api.sandbox.dnsmadeeasy.com should make it work"
      sleep 10

      response = Fog::DNS[:dnsmadeeasy].delete_domain(@domain["name"])
      response.status == 200
    end

  end

  tests( 'failure') do
  end

end
