Shindo.tests('Fog::Compute[:brightbox] | server group requests', ['brightbox']) do

  tests('success') do

    unless Fog.mocking?
      @server = Fog::Compute[:brightbox].servers.create(:image_id => Brightbox::Compute::TestSupport::IMAGE_IDENTIFER)
      server_id = @server.id
    end

    create_options = {
      :name => "Fog@#{Time.now.iso8601}",
      :servers => [{
        :server => server_id
      }]
    }

    tests("#create_server_group(#{create_options.inspect})").formats(Brightbox::Compute::Formats::Full::SERVER_GROUP) do
      pending if Fog.mocking?
      data = Fog::Compute[:brightbox].create_server_group(create_options)
      @server_group_id = data["id"]
      data
    end

    tests("#list_server_groups").formats(Brightbox::Compute::Formats::Collection::SERVER_GROUPS) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].list_server_groups
    end

    tests("#get_server_group('#{@server_group_id}')").formats(Brightbox::Compute::Formats::Full::SERVER_GROUP) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_server_group(@server_group_id)
    end

    update_options = {:name => "Fog@#{Time.now.iso8601}"}
    tests("#update_server_group(#{update_options.inspect})").formats(Brightbox::Compute::Formats::Full::SERVER_GROUP) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].update_server_group(@server_group_id, update_options)
    end

    remove_options = {:servers => [{:server => server_id}]}
    tests("#remove_servers_server_group(#{remove_options.inspect})").formats(Brightbox::Compute::Formats::Full::SERVER_GROUP) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].remove_servers_server_group(@server_group_id, remove_options)
    end

    add_options = {:servers => [{:server => server_id}]}
    tests("#add_servers_server_group(#{remove_options.inspect})").formats(Brightbox::Compute::Formats::Full::SERVER_GROUP) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].add_servers_server_group(@server_group_id, add_options)
    end

    # Server Group must be empty to delete so we need to remove it again
    remove_options = {:servers => [{:server => server_id}]}
    tests("#remove_servers_server_group(#{remove_options.inspect})").formats(Brightbox::Compute::Formats::Full::SERVER_GROUP) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].remove_servers_server_group(@server_group_id, remove_options)
    end

    tests("#destroy_server_group('#{@server_group_id}')").formats(Brightbox::Compute::Formats::Full::SERVER_GROUP) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].destroy_server_group(@server_group_id)
    end

    unless Fog.mocking?
      @server.wait_for { ready? }
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
