Shindo.tests('Fog::Compute[:brightbox] | server type requests', ['brightbox']) do

  tests('success') do

    tests("#list_server_types").formats(Brightbox::Compute::Formats::Collection::SERVER_TYPES) do
      pending if Fog.mocking?
      data = Fog::Compute[:brightbox].list_server_types
      @server_type_id = data.first["id"]
      data
    end

    tests("#get_server_type('#{@server_type_id}')").formats(Brightbox::Compute::Formats::Full::SERVER_TYPE) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_server_type(@server_type_id)
    end

  end

  tests('failure') do

    tests("#get_server_type('typ-00000')").raises(Excon::Errors::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_server_type('typ-00000')
    end

    tests("#get_server").raises(ArgumentError) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_server_type
    end

  end

end
