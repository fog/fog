Shindo.tests("HP::DNS | domain requests", ['hp', 'dns', 'domain']) do
  @domain_format = {
    'id'          => String,
    'name'        => String,
    'description' => String,
    'ttl'         => Integer,
    'serial'      => Integer,
    'email'       => String,
    'created_at'  => String
  }

  @server_format = {
    'id'          => String,
    'name'        => String,
    'created_at'  => String,
    'updated_at'  => String
  }

  tests('success') do

    @domain_name = 'www.fogtest.com.'
    @email = 'test@fogtest.com'

    tests("#create_domain(#{@domain_name}, #{@email})").formats(@domain_format) do
      data = HP[:dns].create_domain(@domain_name, @email).body
      @domain_id = data['id']
      data
    end

    tests('#list_domains').formats({'domains' => [@domain_format]}) do
      HP[:dns].list_domains.body
    end

    tests("#get_domain(#{@domain_id})").formats(@domain_format) do
      HP[:dns].get_domain(@domain_id).body
    end

    tests("#get_servers_hosting_domain(#{@domain_id})").formats('servers' => [@server_format]) do
      HP[:dns].get_servers_hosting_domain(@domain_id).body
    end

    tests("#update_domain(#{@domain_id}, {:email => 'updated@fogtest.com'})").formats(@domain_format) do
      HP[:dns].update_domain(@domain_id, {:email => 'updated@fogtest.com'}).body
    end

    tests("#delete_domain(#{@domain_id})").succeeds do
      HP[:dns].delete_domain(@domain_id)
    end

  end

  tests('failure') do

    tests("#get_domain('invalid_domain')").raises(Fog::HP::DNS::NotFound) do
      HP[:dns].get_domain('invalid_domain')
    end

    tests("#get_servers_hosting_domain('invalid_domain')").raises(Fog::HP::DNS::NotFound) do
      HP[:dns].get_servers_hosting_domain('invalid_domain')
    end

    tests("#update_domain('invalid_domain', {:email => 'updated@fogtest.com'})").raises(Fog::HP::DNS::NotFound) do
      HP[:dns].update_domain('invalid_domain', {:email => 'updated@fogtest.com'})
    end

    tests("#delete_domain('invalid_domain')").raises(Fog::HP::DNS::NotFound) do
      HP[:dns].delete_domain('invalid_domain')
    end

  end

end
