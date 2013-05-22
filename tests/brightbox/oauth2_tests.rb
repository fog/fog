Shindo.tests("Fog::Brightbox::OAuth2", ["brightbox"]) do

  tests("CredentialSet") do
    @client_id     = "app-12345"
    @client_secret = "__mashed_keys_123__"
    @username      = "usr-12345"
    @password      = "__mushed_keys_321__"
    @access_token  = "12efde32fdfe4989"
    @refresh_token = "7894389f9074f071"
    @expires_in    = 7200

    tests("with client credentials") do
      credentials = Fog::Brightbox::OAuth2::CredentialSet.new(@client_id, @client_secret)
      tests("#user_details?").returns(false) { credentials.user_details? }
      tests("#access_token?").returns(false) { credentials.access_token? }
      tests("#refresh_token?").returns(false) { credentials.refresh_token? }
      tests("#best_grant_strategy").returns(true) do
        credentials.best_grant_strategy.is_a?(Fog::Brightbox::OAuth2::ClientCredentialsStrategy)
      end
    end

    tests("with user credentials") do
      options = {:username => @username, :password => @password}
      credentials = Fog::Brightbox::OAuth2::CredentialSet.new(@client_id, @client_secret, options)
      tests("#user_details?").returns(true) { credentials.user_details? }
      tests("#access_token?").returns(false) { credentials.access_token? }
      tests("#refresh_token?").returns(false) { credentials.refresh_token? }
      tests("#best_grant_strategy").returns(true) do
        credentials.best_grant_strategy.is_a?(Fog::Brightbox::OAuth2::UserCredentialsStrategy)
      end
    end

    tests("with existing tokens") do
      options = {
        :username => @username,
        :access_token => @access_token,
        :refresh_token => @refresh_token,
        :expires_in => @expires_in
      }
      credentials = Fog::Brightbox::OAuth2::CredentialSet.new(@client_id, @client_secret, options)
      tests("#user_details?").returns(false) { credentials.user_details? }
      tests("#access_token?").returns(true) { credentials.access_token? }
      tests("#refresh_token?").returns(true) { credentials.refresh_token? }
      tests("#expires_in").returns(7200) { credentials.expires_in }
      tests("#best_grant_strategy").returns(true) do
        credentials.best_grant_strategy.is_a?(Fog::Brightbox::OAuth2::RefreshTokenStrategy)
      end
    end
  end

  tests("GrantTypeStrategy") do
    credentials = Fog::Brightbox::OAuth2::CredentialSet.new(@client_id, @client_secret)
    strategy = Fog::Brightbox::OAuth2::GrantTypeStrategy.new(credentials)

    tests("#respond_to? :authorization_body_data").returns(true) do
      strategy.respond_to?(:authorization_body_data)
    end
  end

  tests("ClientCredentialsStrategy") do
    credentials = Fog::Brightbox::OAuth2::CredentialSet.new(@client_id, @client_secret)
    strategy = Fog::Brightbox::OAuth2::ClientCredentialsStrategy.new(credentials)

    tests("#respond_to? :authorization_body_data").returns(true) do
      strategy.respond_to?(:authorization_body_data)
    end

    tests("#authorization_body_data") do
      authorization_body_data = strategy.authorization_body_data
      test("grant_type == none") { authorization_body_data["grant_type"] == "none" }
      test("client_id == #{@client_id}") { authorization_body_data["client_id"] == @client_id }
    end
  end

  tests("UserCredentialsStrategy") do
    options = {:username => @username, :password => @password}
    credentials = Fog::Brightbox::OAuth2::CredentialSet.new(@client_id, @client_secret, options)
    strategy = Fog::Brightbox::OAuth2::UserCredentialsStrategy.new(credentials)

    tests("#respond_to? :authorization_body_data").returns(true) do
      strategy.respond_to?(:authorization_body_data)
    end

    tests("#authorization_body_data") do
      authorization_body_data = strategy.authorization_body_data
      test("grant_type == password") { authorization_body_data["grant_type"] == "password" }
      test("client_id == #{@client_id}") { authorization_body_data["client_id"] == @client_id }
      test("username == #{@username}") { authorization_body_data["username"] == @username }
      test("password == #{@password}") { authorization_body_data["password"] == @password }
    end
  end

  tests("RefreshTokenStrategy") do
    refresh_token = "ab4b39dddf909"
    options = {:refresh_token => refresh_token}
    credentials = Fog::Brightbox::OAuth2::CredentialSet.new(@client_id, @client_secret, options)
    strategy = Fog::Brightbox::OAuth2::RefreshTokenStrategy.new(credentials)

    tests("#respond_to? :authorization_body_data").returns(true) do
      strategy.respond_to?(:authorization_body_data)
    end

    tests("#authorization_body_data") do
      authorization_body_data = strategy.authorization_body_data
      test("grant_type == refresh_token") { authorization_body_data["grant_type"] == "refresh_token" }
      test("client_id == #{@client_id}") { authorization_body_data["client_id"] == @client_id }
      test("refresh_token == #{refresh_token}") { authorization_body_data["refresh_token"] == refresh_token }
    end
  end
end
