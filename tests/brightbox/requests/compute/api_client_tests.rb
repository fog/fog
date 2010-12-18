Shindo.tests('Brightbox::Compute | api client requests', ['brightbox']) do

  tests('success') do

    create_options = {:name => "Name from Fog test (#{Time.now.to_i})", :description => "Description from Fog test"}

    tests("#create_api_client(#{create_options.inspect})").formats(Brightbox::Compute::Formats::Full::API_CLIENT) do
      pending if Fog.mocking?
      data = Brightbox[:compute].create_api_client(create_options)
      @api_client_id = data["id"]
      data
    end

    tests("#list_api_clients").formats(Brightbox::Compute::Formats::Collection::API_CLIENTS) do
      pending if Fog.mocking?
      Brightbox[:compute].list_api_clients
    end

    tests("#get_api_client('#{@api_client_id}')").formats(Brightbox::Compute::Formats::Full::API_CLIENT) do
      pending if Fog.mocking?
      Brightbox[:compute].get_api_client(@api_client_id)
    end

    tests("#update_api_client('#{@api_client_id}')").formats(Brightbox::Compute::Formats::Full::API_CLIENT) do
      pending if Fog.mocking?
      Brightbox[:compute].update_api_client(@api_client_id, :name => "New name from Fog test")
    end

    tests("#destroy_api_client('#{@api_client_id}')").formats(Brightbox::Compute::Formats::Full::API_CLIENT) do
      pending if Fog.mocking?
      Brightbox[:compute].destroy_api_client(@api_client_id)
    end

  end

  tests('failure') do

    tests("#get_api_client('cli-00000')").raises(Excon::Errors::NotFound) do
      pending if Fog.mocking?
      Brightbox[:compute].get_api_client('cli-00000')
    end

    tests("#get_api_client").raises(ArgumentError) do
      pending if Fog.mocking?
      Brightbox[:compute].get_api_client
    end
  end

end
