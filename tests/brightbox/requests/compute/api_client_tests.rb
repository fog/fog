Shindo.tests('Fog::Compute[:brightbox] | api client requests', ['brightbox']) do

  tests('success') do

    create_options = {
      :name => "Fog@#{Time.now.iso8601}",
      :description => "Description from Fog test"
    }

    tests("#create_api_client(#{create_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].create_api_client(create_options)
      @api_client_id = result["id"]
      formats(Brightbox::Compute::Formats::Full::API_CLIENT, false) { result }
    end

    tests("#list_api_clients") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].list_api_clients
      formats(Brightbox::Compute::Formats::Collection::API_CLIENTS, false) { result }
    end

    tests("#get_api_client('#{@api_client_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].get_api_client(@api_client_id)
      formats(Brightbox::Compute::Formats::Full::API_CLIENT, false) { result }
    end

    update_options = {:name => "Fog@#{Time.now.iso8601}"}
    tests("#update_api_client('#{@api_client_id}', #{update_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].update_api_client(@api_client_id, update_options)
      formats(Brightbox::Compute::Formats::Full::API_CLIENT, false) { result }
    end

    tests("#reset_secret_api_client('#{@api_client_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].reset_secret_api_client(@api_client_id)
      formats(Brightbox::Compute::Formats::Full::API_CLIENT, false) { result }
      test("new secret is visible") { ! result["secret"].nil?  }
    end

    tests("#destroy_api_client('#{@api_client_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].destroy_api_client(@api_client_id)
      formats(Brightbox::Compute::Formats::Full::API_CLIENT, false) { result }
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
