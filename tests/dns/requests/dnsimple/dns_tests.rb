Shindo.tests('DNSimple::dns | DNS requests', ['dnsimple', 'dns']) do

  @domain = ''
  @domain_count = 0

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

  tests("success") do

    test("get current domain count") do
      pending if Fog.mocking?

      response = DNSimple[:dns].list_domains()
      if response.status == 200
        @domain_count = response.body.size
      end

      response.status == 200
    end

    test("create domain") do
      pending if Fog.mocking?

      domain = generate_unique_domain
      response = DNSimple[:dns].create_domain(domain)
      if response.status == 201
        @domain = response.body["domain"]
      end

      response.status == 201
    end

    test("get domain by id") do
      pending if Fog.mocking?

      response = DNSimple[:dns].get_domain(@domain["id"])
      response.status == 200
    end

    test("create an A resource record") do
      pending if Fog.mocking?

      domain = @domain["name"]
      name = "www"
      type = "A"
      content = "1.2.3.4"
      response = DNSimple[:dns].create_record(domain, name, type, content)

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
      response = DNSimple[:dns].create_record(domain, name, type, content, options)

      response.status == 201
    end

    test("update a record") do
      pending if Fog.mocking?

      domain = @domain["name"]
      record_id = @record["id"]
      options = { :content => "2.3.4.5", :ttl => 600 }
      response = DNSimple[:dns].update_record(domain, record_id, options)
      response.status == 200
    end

    test("list records") do
      pending if Fog.mocking?

      response = DNSimple[:dns].list_records(@domain["name"])

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
        response = DNSimple[:dns].delete_record(domain, record["record"]["id"])
        if(response.status != 200)
          result = false
          break
        end
      end

      result
    end

    test("delete domain") do
      pending if Fog.mocking?

      response = DNSimple[:dns].delete_domain(@domain["name"])
      response.status == 200
    end

  end

  tests( 'failure') do
  end

end
