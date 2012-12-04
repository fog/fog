require 'thin'
require 'launchy'
require 'google/api_client'
require 'google/api_client/client_secrets'

# Small helper for the sample apps for performing OAuth 2.0 flows from the
# command line. Starts an embedded server to handle redirects.
class CommandLineOAuthHelper

  def initialize(scope)
    credentials = Google::APIClient::ClientSecrets.load
    @authorization = Signet::OAuth2::Client.new(
      :authorization_uri => credentials.authorization_uri,
      :token_credential_uri => credentials.token_credential_uri,
      :client_id => credentials.client_id,
      :client_secret => credentials.client_secret,
      :redirect_uri => credentials.redirect_uris.first,
      :scope => scope)
  end

  # Request authorization. Opens a browser and waits for response
  def authorize
    auth = @authorization
    url = @authorization.authorization_uri().to_s
    server = Thin::Server.new('0.0.0.0', 3000) do
      run lambda { |env|
          # Exchange the auth code & quit
          req = Rack::Request.new(env)
          auth.code = req['code']
          auth.fetch_access_token!
          server.stop()
          [200, {'Content-Type' => 'text/plain'}, 'OK']
      }
    end

    Launchy.open(url)
    server.start()

    return @authorization
  end
end
