Shindo.tests('Fog::Compute[:brightbox] | server requests', ['brightbox']) do

  tests('success') do

    image_id = Brightbox::Compute::TestSupport.image_id
    server_id = nil

    tests("#create_server(:image => '#{image_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].create_server(:image => image_id)
      server_id = result["id"]
      formats(Brightbox::Compute::Formats::Full::SERVER) { result }
    end

    unless Fog.mocking?
      Fog::Compute[:brightbox].servers.get(server_id).wait_for { ready? }
    end

    tests("#list_servers") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].list_servers
      formats(Brightbox::Compute::Formats::Collection::SERVERS) { result }
    end

    tests("#get_server('#{server_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].get_server(server_id)
      formats(Brightbox::Compute::Formats::Full::SERVER) { result }
    end

    tests("#update_server('#{server_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].update_server(server_id, :name => "Fog@#{Time.now.iso8601}")
      formats(Brightbox::Compute::Formats::Full::SERVER) { result }
    end

    tests("#activate_console_server('#{server_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].activate_console_server(server_id)
      formats(Brightbox::Compute::Formats::Full::SERVER) { result }
    end

    tests("#stop_server('#{server_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].stop_server(server_id)
      formats(Brightbox::Compute::Formats::Full::SERVER) { result }
    end

    tests("#start_server('#{server_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].start_server(server_id)
      formats(Brightbox::Compute::Formats::Full::SERVER) { result }
    end

    tests("#shutdown_server('#{server_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].shutdown_server(server_id)
      formats(Brightbox::Compute::Formats::Full::SERVER) { result }
    end

    tests("#snapshot_server('#{server_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].snapshot_server(server_id)
      formats(Brightbox::Compute::Formats::Full::SERVER) { result }
      snapshot_id = result["id"]
      @snapshot = Fog::Compute[:brightbox].images.get(snapshot_id)
      @snapshot.destroy
    end

    tests("#destroy_server('#{server_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].destroy_server(server_id)
      formats(Brightbox::Compute::Formats::Full::SERVER) { result }
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
