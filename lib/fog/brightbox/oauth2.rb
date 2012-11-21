# This module covers Brightbox's partial implementation of OAuth 2.0
# and enables fog clients to implement several authentictication strategies
#
# @see http://tools.ietf.org/html/draft-ietf-oauth-v2-10
#
module Fog::Brightbox::OAuth2

  # Encapsulates credentials required to request access tokens from the
  # Brightbox authorisation servers
  #
  # @todo Interface to update certain credentials (after password change)
  #
  class CredentialSet
    attr_reader :client_id, :client_secret, :username, :password
    #
    # @param [String] client_id
    # @param [String] client_secret
    # @param [Hash] options
    # @option options [String] :username
    # @option options [String] :password
    #
    def initialize(client_id, client_secret, options = {})
      @client_id     = client_id
      @client_secret = client_secret
      @username      = options[:username]
      @password      = options[:password]
    end

    # Returns true if user details are available
    # @return [Boolean]
    def user_details?
      !!(@username && @password)
    end
  end

  # This strategy class is the basis for OAuth2 grant types
  #
  # @abstract Need to implement {#authorization_body_data} to return a
  #   Hash matching the expected parameter form for the OAuth request
  #
  # @todo Strategies should be able to validate if credentials are suitable
  #   so just client credentials cannot be used with user strategies
  #
  class GrantTypeStrategy
    def initialize(credentials)
      @credentials = credentials
    end

    def authorization_body_data
      raise "Not implemented"
    end
  end

  # This implements client based authentication/authorization
  # based on the existing trust relationship using the `none`
  # grant type.
  #
  class ClientCredentialsStrategy < GrantTypeStrategy
    def authorization_body_data
      {
        "grant_type" => "none",
        "client_id"  => @credentials.client_id
      }
    end
  end

  # This passes user details through so the returned token
  # carries the privileges of the user not account limited
  # by the client
  #
  class UserCredentialsStrategy < GrantTypeStrategy
    def authorization_body_data
      {
        "grant_type" => "password",
        "client_id"  => @credentials.client_id,
        "username"   => @credentials.username,
        "password"   => @credentials.password
      }
    end
  end
end
