Shindo.tests("Fog::Brightbox::OAuth2", ["brightbox"]) do

  tests("CredentialSet") do
    @client_id     = "app-12345"
    @client_secret = "__mashed_keys_123__"
    @username      = "usr-12345"
    @password      = "__mushed_keys_321__"

    tests("with client credentials") do
      credentials = Fog::Brightbox::OAuth2::CredentialSet.new(@client_id, @client_secret)
      tests("#user_details?").returns(false) { credentials.user_details? }
    end

    tests("with user credentials") do
      options = {:username => @username, :password => @password}
      credentials = Fog::Brightbox::OAuth2::CredentialSet.new(@client_id, @client_secret, options)
      tests("#user_details?").returns(true) { credentials.user_details? }
    end
  end
end
