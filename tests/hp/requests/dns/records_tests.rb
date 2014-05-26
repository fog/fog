Shindo.tests("HP::DNS | record requests", ['hp', 'dns', 'record']) do
  @record_format = {
    'id'          => String,
    'name'        => String,
    'description' => String,
    'type'        => String,
    'domain_id'   => String,
    'ttl'         => Integer,
    'data'        => String,
    'priority'    => Fog::Nullable::Integer,
    'created_at'  => String,
    'updated_at'  => String
  }

  tests('success') do

    @domain_name = 'www.fogtest.com.'
    @email = 'test@fogtest.com'
    @domain_id = HP[:dns].create_domain(@domain_name, @email).body['id']
    @record_name = 'www.fogtest.com.'
    @record_data = '15.185.172.152'

    tests("#create_record(#{@domain_id}, #{@record_name}, 'A', #{@record_data})").formats(@record_format) do
      data = HP[:dns].create_record(@domain_id, @record_name, 'A', @record_data).body
      @record_id = data['id']
      data
    end

    tests("#list_records_in_a_domain(#{@domain_id})").formats({'records' => [@record_format]}) do
      HP[:dns].list_records_in_a_domain(@domain_id).body
    end

    tests("#get_record(#{@domain_id}, #{@record_id})").formats(@record_format) do
      HP[:dns].get_record(@domain_id, @record_id).body
    end

    tests("#update_record(#{@domain_id}, #{@record_id}, {:description => 'desc for record'})").formats(@record_format) do
      HP[:dns].update_record(@domain_id, @record_id, {:description => 'desc for record'}).body
    end

    tests("#delete_record(#{@domain_id}, #{@record_id})").succeeds do
      HP[:dns].delete_record(@domain_id, @record_id)
    end

    HP[:dns].delete_domain(@domain_id)
  end

  tests('failure') do

    tests("#get_record(#{@domain_id}, 'invalid_record')").raises(Fog::HP::DNS::NotFound) do
      HP[:dns].get_record(@domain_id, 'invalid_record')
    end

    tests("#update_record(#{@domain_id}, 'invalid_record', {:email => 'updated@fogtest.com'})").raises(Fog::HP::DNS::NotFound) do
      HP[:dns].update_record(@domain_id, 'invalid_record', {:email => 'updated@fogtest.com'})
    end

    tests("#delete_record(#{@domain_id}, 'invalid_record')").raises(Fog::HP::DNS::NotFound) do
      HP[:dns].delete_record(@domain_id, 'invalid_record')
    end

  end

end
