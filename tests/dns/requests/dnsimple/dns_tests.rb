Shindo.tests('DNSimple::dns | DNS requests', ['dnsimple', 'dns']) do

  @domain = ''
  @domain_count = 0
  @new_domains = []
  @new_records = []

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

    test('get current domain count') do
      pending if Fog.mocking?

      response = DNSimple[:dns].list_domains()
      if response.status == 200
        @domain_count = response.body.size
      end

      response.status == 200
    end

    test('create domain') do
      pending if Fog.mocking?

      domain = generate_unique_domain
      response = DNSimple[:dns].create_domain(domain)
      if response.status == 201
        @new_domains << response.body
      end

      response.status == 201
    end

    test('get domain by id') do
      pending if Fog.mocking?

      id = @new_domains.first["domain"]["id"]
      response = DNSimple[:dns].get_domain(id)

      response.status == 200
    end

    test("delete #{@new_domains.count} domains created") do
      pending if Fog.mocking?

      result = true

      @new_domains.each do |domain|
        name = domain["domain"]["name"]
        response = DNSimple[:dns].delete_domain(name)
        if response.status != 200
          result= false;
        end
      end

      result
    end

  end

  tests( 'failure') do
  end

end
