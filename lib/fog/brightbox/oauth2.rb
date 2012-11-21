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
end
