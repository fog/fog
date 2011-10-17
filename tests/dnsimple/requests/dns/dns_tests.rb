Shindo.tests('Fog::DNS[:dnsimple] | DNS requests', ['dnsimple', 'dns']) do

  @domain = ''
  @domain_count = 0

  tests("success") do

    test("get current domain count") do
      pending if Fog.mocking?

      response = Fog::DNS[:dnsimple].list_domains()
      if response.status == 200
        @domain_count = response.body.size
      end

      response.status == 200
    end

    test("create domain") do
      pending if Fog.mocking?

      domain = generate_unique_domain
      response = Fog::DNS[:dnsimple].create_domain(domain)
      if response.status == 201
        @domain = response.body["domain"]
      end

      response.status == 201
    end

    test("get domain by id") do
      pending if Fog.mocking?

      response = Fog::DNS[:dnsimple].get_domain(@domain["id"])
      response.status == 200
    end

    test("create an A resource record") do
      pending if Fog.mocking?

      domain = @domain["name"]
      name = "www"
      type = "A"
      content = "1.2.3.4"
      response = Fog::DNS[:dnsimple].create_record(domain, name, type, content)

      if response.status == 201
        @record = response.body["record"]
      end

      response.status == 201

    end

    test("create a MX record") do
      pending if Fog.mocking?

      domain = @domain["name"]
      name = ""
      type = "MX"
      content = "mail.#{domain}"
      options = { :ttl => 60, :prio => 10 }
      response = Fog::DNS[:dnsimple].create_record(domain, name, type, content, options)

      response.status == 201
    end

    test("update a record") do
      pending if Fog.mocking?

      domain = @domain["name"]
      record_id = @record["id"]
      options = { :content => "2.3.4.5", :ttl => 600 }
      response = Fog::DNS[:dnsimple].update_record(domain, record_id, options)
      response.status == 200
    end

    test("list records") do
      pending if Fog.mocking?

      response = Fog::DNS[:dnsimple].list_records(@domain["name"])

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
        response = Fog::DNS[:dnsimple].delete_record(domain, record["record"]["id"])
        if(response.status != 200)
          result = false
          break
        end
      end

      result
    end

    test("delete domain") do
      pending if Fog.mocking?

      response = Fog::DNS[:dnsimple].delete_domain(@domain["name"])
      response.status == 200
    end

  end

  tests( 'failure') do
  end

end
