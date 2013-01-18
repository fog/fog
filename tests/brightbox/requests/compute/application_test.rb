Shindo.tests('Fog::Compute[:brightbox] | api client requests', ['brightbox']) do

  tests('success') do

    create_options = {
      :name => "Fog@#{Time.now.iso8601}"
    }

    tests("#create_application(#{create_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].create_application(create_options)
      @application_id = result["id"]
      formats(Brightbox::Compute::Formats::Full::APPLICATION, false) { result }
    end

    tests("#list_applications") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].list_applications
      formats(Brightbox::Compute::Formats::Collection::APPLICATION, false) { result }
    end

    tests("#get_application('#{@application_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].get_application(@application_id)
      formats(Brightbox::Compute::Formats::Full::APPLICATION, false) { result }
    end

    update_options = {:name => "Fog@#{Time.now.iso8601}"}
    tests("#update_application('#{@application_id}', #{update_options.inspect})") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].update_application(@application_id, update_options)
      formats(Brightbox::Compute::Formats::Full::APPLICATION, false) { result }
    end

    tests("#reset_secret_application('#{@application_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].reset_secret_application(@application_id)
      formats(Brightbox::Compute::Formats::Full::APPLICATION, false) { result }
      test("new secret is visible") { ! result["secret"].nil?  }
    end

    tests("#destroy_application('#{@application_id}')") do
      pending if Fog.mocking?
      result = Fog::Compute[:brightbox].destroy_application(@application_id)
      formats(Brightbox::Compute::Formats::Full::APPLICATION, false) { result }
    end

  end

  tests('failure') do

    tests("#get_api_client('app-00000')").raises(Excon::Errors::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_application('app-00000')
    end

    tests("#get_api_client").raises(ArgumentError) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_application
    end
  end

end
