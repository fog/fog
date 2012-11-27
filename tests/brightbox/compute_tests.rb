Shindo.tests('Fog::Compute[:brightbox]', ['brightbox']) do

  @test_service = Fog::Compute[:brightbox]

  tests("#respond_to? :default_image").returns(true) do
    @test_service.respond_to?(:default_image)
  end

end

Shindo.tests('Fog::Compute.new', ['brightbox']) do

  tests("service options") do
    {
      :brightbox_api_url => "https://example.com",
      :brightbox_auth_url => "https://example.com",
      :brightbox_client_id => "app-12345",
      :brightbox_secret => "12345abdef6789",
      :brightbox_username => "user-12345",
      :brightbox_password => "password1234",
      :brightbox_account => "acc-12345",
      :brightbox_access_token => "12345abdef6789",
      :brightbox_refresh_token => "12345abdef6789",
      :brightbox_token_management => false
    }.each_pair do |option, sample|
      tests("recognises :#{option}").returns(true) do
        options = {:provider => "Brightbox"}
        options[option] = sample
        begin
          Fog::Compute.new(options)
          true
        rescue ArgumentError
          false
        end
      end
    end
  end

  tests("automatic token management") do
    service_options = {:provider => "Brightbox"}

    tests("when enabled (default)") do
      service_options[:brightbox_token_management] = true

      tests("using bad token") do
        service_options[:brightbox_access_token] = "bad-token"

        tests("#request").returns(true, "returns a Hash") do
          service = Fog::Compute.new(service_options)
          response = service.get_authenticated_user
          response.is_a?(Hash) # This is an outstanding issue, should be Excon::Response
        end
      end
    end

    tests("when disabled") do
      service_options[:brightbox_token_management] = false

      tests("using bad token") do
        service_options[:brightbox_access_token] = "bad-token"

        tests("#request").raises(Excon::Errors::Unauthorized) do
          service = Fog::Compute.new(service_options)
          service.get_authenticated_user
        end
      end
    end
  end
end
