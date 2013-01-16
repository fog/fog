Shindo.tests('Fog::Compute[:brightbox] | server requests', ['brightbox']) do

  tests('success') do

    unless Fog.mocking?
      image_id = Brightbox::Compute::TestSupport.image_id
      server_id = nil
    end

    tests("#create_server(:image => '#{image_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].create_server(:image => image_id)
      server_id = result["id"]
      data_matches_schema(Brightbox::Compute::Formats::Full::SERVER, {:allow_extra_keys => true}) { result }
    end

    unless Fog.mocking?
      Fog::Compute[:brightbox].servers.get(server_id).wait_for { ready? }
    end

    tests("#list_servers") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].list_servers
      data_matches_schema(Brightbox::Compute::Formats::Collection::SERVERS, {:allow_extra_keys => true}) { result }
    end

    tests("#get_server('#{server_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].get_server(server_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::SERVER, {:allow_extra_keys => true}) { result }
    end

    tests("#update_server('#{server_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].update_server(server_id, :name => "Fog@#{Time.now.iso8601}")
      data_matches_schema(Brightbox::Compute::Formats::Full::SERVER, {:allow_extra_keys => true}) { result }
    end

    tests("#activate_console_server('#{server_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].activate_console_server(server_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::SERVER, {:allow_extra_keys => true}) { result }
      test("has set 'console_url'") { ! result["console_url"].empty? }
      test("has set 'console_token'") { ! result["console_token"].empty? }
      test("has set 'console_token_expires'") { ! result["console_token_expires"].empty? }
    end

    tests("#stop_server('#{server_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].stop_server(server_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::SERVER, {:allow_extra_keys => true}) { result }
    end

    tests("#start_server('#{server_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].start_server(server_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::SERVER, {:allow_extra_keys => true}) { result }
    end

    tests("#shutdown_server('#{server_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].shutdown_server(server_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::SERVER, {:allow_extra_keys => true}) { result }
    end

    tests("#snapshot_server('#{server_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].snapshot_server(server_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::SERVER, {:allow_extra_keys => true}) { result }
      # Server should be exclusively for our test so assume we can delete the snapshot
      snapshot_id = result["snapshots"].first["id"]
      @snapshot = Fog::Compute[:brightbox].images.get(snapshot_id)
      @snapshot.wait_for { ready? }
      @snapshot.destroy
    end

    tests("#destroy_server('#{server_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].destroy_server(server_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::SERVER, {:allow_extra_keys => true}) { result }
    end

  end

  tests('failure') do

    tests("#get_server('srv-00000')").raises(Excon::Errors::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_server('srv-00000')
    end

    tests("#get_server").raises(ArgumentError) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_server
    end

  end

end
