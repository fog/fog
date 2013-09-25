Shindo.tests('Fog::Compute[:brightbox] | server group requests', ['brightbox']) do

  tests('success') do

    unless Fog.mocking?
      @server = Brightbox::Compute::TestSupport.get_test_server
      server_id = @server.id
    end

    create_options = {
      :name => "Fog@#{Time.now.iso8601}",
      :servers => [{
        :server => server_id
      }]
    }

    tests("#create_server_group(#{create_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].create_server_group(create_options)
      @server_group_id = result["id"]
      data_matches_schema(Brightbox::Compute::Formats::Full::SERVER_GROUP, {:allow_extra_keys => true}) { result }
    end

    tests("#list_server_groups") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].list_server_groups
      data_matches_schema(Brightbox::Compute::Formats::Collection::SERVER_GROUPS, {:allow_extra_keys => true}) { result }
      @default_group_id = result.select {|grp| grp["default"] == true }.first["id"]
    end

    tests("#get_server_group('#{@server_group_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].get_server_group(@server_group_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::SERVER_GROUP, {:allow_extra_keys => true}) { result }
    end

    update_options = {:name => "Fog@#{Time.now.iso8601}"}
    tests("#update_server_group('#{@server_group_id}', #{update_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].update_server_group(@server_group_id, update_options)
      data_matches_schema(Brightbox::Compute::Formats::Full::SERVER_GROUP, {:allow_extra_keys => true}) { result }
    end

    remove_options = {:servers => [{:server => server_id}]}
    tests("#remove_servers_server_group('#{@server_group_id}', #{remove_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].remove_servers_server_group(@server_group_id, remove_options)
      data_matches_schema(Brightbox::Compute::Formats::Full::SERVER_GROUP, {:allow_extra_keys => true}) { result }
    end

    add_options = {:servers => [{:server => server_id}]}
    tests("#add_servers_server_group('#{@server_group_id}', #{remove_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].add_servers_server_group(@server_group_id, add_options)
      data_matches_schema(Brightbox::Compute::Formats::Full::SERVER_GROUP, {:allow_extra_keys => true}) { result }
    end

    move_options = {:destination => @default_group_id, :servers => [{:server => server_id}]}
    tests("#move_servers_server_group('#{@server_group_id}', #{move_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].move_servers_server_group(@server_group_id, move_options)
      data_matches_schema(Brightbox::Compute::Formats::Full::SERVER_GROUP, {:allow_extra_keys => true}) { result }
      test("group is emptied") { result["servers"].empty? }
    end

    tests("#destroy_server_group('#{@server_group_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].destroy_server_group(@server_group_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::SERVER_GROUP, {:allow_extra_keys => true}) { result }
    end

    unless Fog.mocking?
      @server.destroy
    end

  end

  tests('failure') do

    tests("#create_server_group").raises(ArgumentError) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].create_server_group
    end

    tests("#get_server_group('grp-00000')").raises(Excon::Errors::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_server_group('grp-00000')
    end

    tests("#get_server_group").raises(ArgumentError) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_server_group
    end
  end

end
