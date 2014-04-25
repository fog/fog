#
# Author:: Matt Eldridge (<matt.eldridge@us.ibm.com>)
# © Copyright IBM Corporation 2014.
#
# LICENSE: MIT (http://opensource.org/licenses/MIT)
#

module Fog
  module Softlayer
    module Compute

      # The Shared module consists of code that was duplicated between the Real
      # and Mock implementations.
      #
      module Shared

        # Creates a new instance of the Softlayer Compute service
        #
        # @param [Hash] options
        # @option options [String] :softlayer_api_url
        #   Override the default (or configured) API endpoint
        # @option options [String] :softlayer_username
        #   Email or user identifier for user based authentication
        # @option options [String] :softlayer_api_key
        #   Password for user based authentication
        #
        def initialize(options)
          @api_url             = options[:softlayer_api_url]   || API_URL
          @credentials   = { :username => options[:softlayer_username], :api_key => options[:softlayer_api_key] }
          @default_domain = options[:softlayer_default_domain]
        end

        def self.valid_request?(required, passed)
          required.all? {|k| passed.key?(k)}
        end

      end
    end
  end
end
