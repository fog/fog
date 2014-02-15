Shindo.tests('Fog::Compute[:brightbox] | database server requests', ['brightbox']) do
  pending if Fog.mocking?

  tests('success') do

    create_options = {}
    tests("#create_database_server(#{create_options.inspect})") do
      result = Fog::Compute[:brightbox].create_database_server(create_options)
      @database_server_id = result["id"]
      data_matches_schema(Brightbox::Compute::Formats::Full::DATABASE_SERVER, {:allow_extra_keys => true}) { result }
    end

    tests("#list_database_servers") do
      result = Fog::Compute[:brightbox].list_database_servers
      data_matches_schema(Brightbox::Compute::Formats::Collection::DATABASE_SERVERS, {:allow_extra_keys => true}) { result }
    end

    tests("#get_database_server('#{@database_server_id}')") do
      result = Fog::Compute[:brightbox].get_database_server(@database_server_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::DATABASE_SERVER, {:allow_extra_keys => true}) { result }
    end

    update_options = {
      :name => "New name"
    }
    tests("#update_database_server('#{@database_server_id}', update_options)") do
      result = Fog::Compute[:brightbox].update_database_server(@database_server_id, update_options)
      data_matches_schema(Brightbox::Compute::Formats::Full::DATABASE_SERVER, {:allow_extra_keys => true}) { result }
    end

    tests("#reset_password_database_server('#{@database_server_id}')") do
      result = Fog::Compute[:brightbox].reset_password_database_server(@database_server_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::DATABASE_SERVER, {:allow_extra_keys => true}) { result }
      test("new password is visible") { ! result["admin_password"].nil? }
    end

    Fog::Compute[:brightbox].database_servers.get(@database_server_id).wait_for { ready? }

    tests("#destroy_database_server('#{@database_server_id}')") do
      result = Fog::Compute[:brightbox].destroy_database_server(@database_server_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::DATABASE_SERVER, {:allow_extra_keys => true}) { result }
    end
  end

  tests('failure') do
    tests("create_database_server").raises(ArgumentError) do
      Fog::Compute[:brightbox].create_database_server
    end

    tests("get_database_server").raises(Excon::Errors::NotFound) do
      Fog::Compute[:brightbox].get_database_server("dbs-00000")
    end
  end
end
