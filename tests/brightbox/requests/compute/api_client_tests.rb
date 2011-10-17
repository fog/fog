Shindo.tests('Fog::Compute[:brightbox] | api client requests', ['brightbox']) do

  tests('success') do

    create_options = {
      :name => "Fog@#{Time.now.iso8601}",
      :description => "Description from Fog test"
    }

    tests("#create_api_client(#{create_options.inspect})").formats(Brightbox::Compute::Formats::Full::API_CLIENT) do
      pending if Fog.mocking?
      data = Fog::Compute[:brightbox].create_api_client(create_options)
      @api_client_id = data["id"]
      data
    end

    tests("#list_api_clients").formats(Brightbox::Compute::Formats::Collection::API_CLIENTS) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].list_api_clients
    end

    tests("#get_api_client('#{@api_client_id}')").formats(Brightbox::Compute::Formats::Full::API_CLIENT) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_api_client(@api_client_id)
    end

    update_options = {:name => "Fog@#{Time.now.iso8601}"}
    tests("#update_api_client('#{@api_client_id}')").formats(Brightbox::Compute::Formats::Full::API_CLIENT) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].update_api_client(@api_client_id, update_options)
    end

    tests("#destroy_api_client('#{@api_client_id}')").formats(Brightbox::Compute::Formats::Full::API_CLIENT) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].destroy_api_client(@api_client_id)
    end

  end

  tests('failure') do

    tests("#get_api_client('cli-00000')").raises(Excon::Errors::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_api_client('cli-00000')
    end

    tests("#get_api_client").raises(ArgumentError) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_api_client
    end
  end

end
