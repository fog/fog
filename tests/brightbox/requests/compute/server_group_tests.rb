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
      formats(Brightbox::Compute::Formats::Full::SERVER_GROUP, false) { result }
    end

    tests("#list_server_groups") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].list_server_groups
      formats(Brightbox::Compute::Formats::Collection::SERVER_GROUPS, false) { result }
      @default_group_id = result.select {|grp| grp["default"] == true }.first["id"]
    end

    tests("#get_server_group('#{@server_group_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].get_server_group(@server_group_id)
      formats(Brightbox::Compute::Formats::Full::SERVER_GROUP, false) { result }
    end

    update_options = {:name => "Fog@#{Time.now.iso8601}"}
    tests("#update_server_group('#{@server_group_id}', #{update_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].update_server_group(@server_group_id, update_options)
      formats(Brightbox::Compute::Formats::Full::SERVER_GROUP, false) { result }
    end

    remove_options = {:servers => [{:server => server_id}]}
    tests("#remove_servers_server_group('#{@server_group_id}', #{remove_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].remove_servers_server_group(@server_group_id, remove_options)
      formats(Brightbox::Compute::Formats::Full::SERVER_GROUP, false) { result }
    end

    add_options = {:servers => [{:server => server_id}]}
    tests("#add_servers_server_group('#{@server_group_id}', #{remove_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].add_servers_server_group(@server_group_id, add_options)
      formats(Brightbox::Compute::Formats::Full::SERVER_GROUP, false) { result }
    end

    move_options = {:destination => @default_group_id, :servers => [{:server => server_id}]}
    tests("#move_servers_server_group('#{@server_group_id}', #{move_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].move_servers_server_group(@server_group_id, move_options)
      formats(Brightbox::Compute::Formats::Full::SERVER_GROUP, false) { result }
      test("group is emptied") { result["servers"].empty? }
    end

    tests("#destroy_server_group('#{@server_group_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].destroy_server_group(@server_group_id)
      formats(Brightbox::Compute::Formats::Full::SERVER_GROUP, false) { result }
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
