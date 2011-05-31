Shindo.tests('AWS::SimpleDB | attributes requests', ['aws']) do

  @domain_name = "fog_domain_#{Time.now.to_f.to_s.gsub('.','')}"

  AWS[:sdb].create_domain(@domain_name)

  tests('success') do

    tests("#batch_put_attributes('#{@domain_name}', { 'a' => { 'b' => 'c', 'd' => 'e' }, 'x' => { 'y' => 'z' } }).body").formats(AWS::SimpleDB::Formats::BASIC) do
      AWS[:sdb].batch_put_attributes(@domain_name, { 'a' => { 'b' => 'c', 'd' => 'e' }, 'x' => { 'y' => 'z' } }).body
    end

    tests("#get_attributes('#{@domain_name}', 'a').body['Attributes']").returns({'b' => ['c'], 'd' => ['e']}) do
      attributes = {}
      Fog.wait_for {
        attributes = AWS[:sdb].get_attributes(@domain_name, 'a').body['Attributes']
        attributes != {}
      }
      attributes
    end

    tests("#get_attributes('#{@domain_name}', 'notanattribute')").succeeds do
      AWS[:sdb].get_attributes(@domain_name, 'notanattribute')
    end

    tests("#select('select * from #{@domain_name}').body['Items']").returns({'a' => { 'b' => ['c'], 'd' => ['e']}, 'x' => { 'y' => ['z'] } }) do
      pending if Fog.mocking?
      AWS[:sdb].select("select * from #{@domain_name}").body['Items']
    end

    tests("#put_attributes('#{@domain_name}', 'conditional', { 'version' => '1' }).body").formats(AWS::SimpleDB::Formats::BASIC) do
      AWS[:sdb].put_attributes(@domain_name, 'conditional', { 'version' => '1' }).body
    end

    tests("#put_attributes('#{@domain_name}', 'conditional', { 'version' => '2' }, :expect => { 'version' => '1' }, :replace => ['version']).body").formats(AWS::SimpleDB::Formats::BASIC) do
      AWS[:sdb].put_attributes(@domain_name, 'conditional', { 'version' => '2' }, :expect => { 'version' => '1' }, :replace => ['version']).body
    end

    # Verify that we can delete individual attributes.
    tests("#delete_attributes('#{@domain_name}', 'a', {'d' => []})").succeeds do
      AWS[:sdb].delete_attributes(@domain_name, 'a', {'d' => []}).body
    end

    # Verify that individually deleted attributes are actually removed.
    tests("#get_attributes('#{@domain_name}', 'a', ['d']).body['Attributes']").returns({'d' => nil}) do
      AWS[:sdb].get_attributes(@domain_name, 'a', ['d']).body['Attributes']
    end

    tests("#delete_attributes('#{@domain_name}', 'a').body").formats(AWS::SimpleDB::Formats::BASIC) do
      AWS[:sdb].delete_attributes(@domain_name, 'a').body
    end

    # Verify that we can delete entire domain, item combinations.
    tests("#delete_attributes('#{@domain_name}', 'a').body").succeeds do
      AWS[:sdb].delete_attributes(@domain_name, 'a').body
    end

    # Verify that deleting a domain, item combination removes all related attributes.
    tests("#get_attributes('#{@domain_name}', 'a').body['Attributes']").returns({}) do
      AWS[:sdb].get_attributes(@domain_name, 'a').body['Attributes']
    end

  end

  tests('failure') do

    tests("#batch_put_attributes('notadomain', { 'a' => { 'b' => 'c' }, 'x' => { 'y' => 'z' } })").raises(Excon::Errors::BadRequest) do
      AWS[:sdb].batch_put_attributes('notadomain', { 'a' => { 'b' => 'c' }, 'x' => { 'y' => 'z' } })
    end

    tests("#get_attributes('notadomain', 'a')").raises(Excon::Errors::BadRequest) do
      AWS[:sdb].get_attributes('notadomain', 'a')
    end

    tests("#put_attributes('notadomain', 'conditional', { 'version' => '1' })").raises(Excon::Errors::BadRequest) do
      AWS[:sdb].put_attributes('notadomain', 'foo', { 'version' => '1' })
    end

    tests("#put_attributes('#{@domain_name}', 'conditional', { 'version' => '2' }, :expect => { 'version' => '1' }, :replace => ['version'])").raises(Excon::Errors::Conflict) do
      AWS[:sdb].put_attributes(@domain_name, 'conditional', { 'version' => '2' }, :expect => { 'version' => '1' }, :replace => ['version'])
    end

    tests("#delete_attributes('notadomain', 'a')").raises(Excon::Errors::BadRequest) do
      AWS[:sdb].delete_attributes('notadomain', 'a')
    end

  end

  AWS[:sdb].delete_domain(@domain_name)

end
