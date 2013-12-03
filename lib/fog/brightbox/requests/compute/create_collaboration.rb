module Fog
  module Compute
    class Brightbox
      class Real
        # Creates a new collaboration for a user for the account
        #
        # @param [Hash] options
        # @option options [String] :email Email address of user to invite
        # @option options [String] :role Role to grant to the user. Currently only `admin`
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#collaboration_create_collaboration
        #
        def create_collaboration(options)
          wrapped_request("post", "/1.0/collaborations", [201], options)
        end

      end
    end
  end
end
