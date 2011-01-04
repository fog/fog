Shindo.tests('AWS::SimpleDB | domain requests', ['aws']) do

  @domain_metadata_format = AWS::SimpleDB::Formats::BASIC.merge({
    'AttributeNameCount'        => Integer,
    'AttributeNamesSizeBytes'   => Integer,
    'AttributeValueCount'       => Integer,
    'AttributeValuesSizeBytes'  => Integer,
    'ItemCount'                 => Integer,
    'ItemNamesSizeBytes'        => Integer,
    'Timestamp'                 => Time
  })

  @domain_name = "fog_domain_#{Time.now.to_f.to_s.gsub('.','')}"

  tests('success') do

    tests("#create_domain(#{@domain_name})").formats(AWS::SimpleDB::Formats::BASIC) do
      AWS[:sdb].create_domain(@domain_name).body
    end

    tests("#create_domain(#{@domain_name})").succeeds do
      AWS[:sdb].create_domain(@domain_name)
    end

    tests("#domain_metadata(#{@domain_name})").formats(@domain_metadata_format) do
      AWS[:sdb].domain_metadata(@domain_name).body
    end

    tests("#list_domains").formats(AWS::SimpleDB::Formats::BASIC.merge('Domains' => [String])) do
      AWS[:sdb].list_domains.body
    end

    tests("#delete_domain(#{@domain_name})").formats(AWS::SimpleDB::Formats::BASIC) do
      AWS[:sdb].delete_domain(@domain_name).body
    end

    tests("#delete_domain(#{@domain_name})").succeeds do
      AWS[:sdb].delete_domain(@domain_name)
    end

  end

  tests('failure') do

    tests("#domain_metadata('notadomain')").raises(Excon::Errors::BadRequest) do
      AWS[:sdb].domain_metadata('notadomain')
    end

  end

end
