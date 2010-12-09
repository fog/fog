Shindo.tests('Brightbox::Compute | server requests', ['brightbox']) do

  tests('success') do

    image_id = Brightbox::Compute::TestSupport::IMAGE_IDENTIFER
    server_id = nil

    tests("#create_server(:image => '#{image_id}')").formats(Brightbox::Compute::Formats::Full::SERVER) do
      data = Brightbox[:compute].create_server(:image => image_id)
      server_id = data["id"]
      data
    end

    Brightbox[:compute].servers.get(server_id).wait_for { ready? }

    tests("#list_servers()").formats(Brightbox::Compute::Formats::Collection::SERVERS) do
      Brightbox[:compute].list_servers()
    end

    tests("#get_server('#{server_id}')").formats(Brightbox::Compute::Formats::Full::SERVER) do
      Brightbox[:compute].get_server(server_id)
    end

    tests("#update_server('#{server_id}')").formats(Brightbox::Compute::Formats::Full::SERVER) do
      Brightbox[:compute].update_server(server_id, :name => "New name from Fog test")
    end

    tests("#stop_server('#{server_id}')").formats(Brightbox::Compute::Formats::Full::SERVER) do
      Brightbox[:compute].stop_server(server_id)
    end

    tests("#start_server('#{server_id}')").formats(Brightbox::Compute::Formats::Full::SERVER) do
      Brightbox[:compute].start_server(server_id)
    end

    tests("#shutdown_server('#{server_id}')").formats(Brightbox::Compute::Formats::Full::SERVER) do
      Brightbox[:compute].shutdown_server(server_id)
    end

    tests("#destroy_server('#{server_id}')").formats(Brightbox::Compute::Formats::Full::SERVER) do
      Brightbox[:compute].destroy_server(server_id)
    end

  end

  tests('failure') do

    tests("#get_server('srv-00000')").raises(Excon::Errors::NotFound) do
      Brightbox[:compute].get_server('srv-00000')
    end

    tests("#get_server()").raises(ArgumentError) do
      Brightbox[:compute].get_server()
    end
  end

end
