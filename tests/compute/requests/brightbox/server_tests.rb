Shindo.tests('Fog::Compute[:brightbox] | server requests', ['brightbox']) do

  tests('success') do

    image_id = Brightbox::Compute::TestSupport::IMAGE_IDENTIFER
    server_id = nil

    tests("#create_server(:image => '#{image_id}')").formats(Brightbox::Compute::Formats::Full::SERVER) do
      pending if Fog.mocking?
      data = Fog::Compute[:brightbox].create_server(:image => image_id)
      server_id = data["id"]
      data
    end

    unless Fog.mocking?
      Fog::Compute[:brightbox].servers.get(server_id).wait_for { ready? }
    end

    tests("#list_servers").formats(Brightbox::Compute::Formats::Collection::SERVERS) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].list_servers
    end

    tests("#get_server('#{server_id}')").formats(Brightbox::Compute::Formats::Full::SERVER) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_server(server_id)
    end

    tests("#update_server('#{server_id}')").formats(Brightbox::Compute::Formats::Full::SERVER) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].update_server(server_id, :name => "Fog@#{Time.now.iso8601}")
    end

    tests("#activate_console_server('#{server_id}')").formats(Brightbox::Compute::Formats::Full::SERVER) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].activate_console_server(server_id)
    end

    tests("#stop_server('#{server_id}')").formats(Brightbox::Compute::Formats::Full::SERVER) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].stop_server(server_id)
    end

    tests("#start_server('#{server_id}')").formats(Brightbox::Compute::Formats::Full::SERVER) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].start_server(server_id)
    end

    tests("#shutdown_server('#{server_id}')").formats(Brightbox::Compute::Formats::Full::SERVER) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].shutdown_server(server_id)
    end

    tests("#destroy_server('#{server_id}')").formats(Brightbox::Compute::Formats::Full::SERVER) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].destroy_server(server_id)
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
