require 'google/api_client'
require 'google/api_client/client_secrets'

# Small helper for the sample apps for performing OAuth 2.0 flows from the
# command line. Starts an embedded server to handle redirects.
class CommandLineOAuthHelper

  def initialize(scope)
    credentials = Google::APIClient::ClientSecrets.load
    @authorization = Signet::OAuth2::Client.new(
      :audience => 'https://accounts.google.com/o/oauth2/token',
      :issuer => "#{crendentials.client_id}@developer.gserviceaccount.com",
      :redirect_uri => credentials.redirect_uris.first,
      :scope => scope,
      :signing_key => credentials.signing_key,
      :token_credential_uri => credentials.token_credential_uri,
    )
    @authorization.fetch_access_token!
  end

  def authorize
    return @authorization
  end
end
