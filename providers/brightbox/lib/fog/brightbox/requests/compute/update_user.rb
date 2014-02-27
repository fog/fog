module Fog
  module Compute
    class Brightbox
      class Real
        # Update some details of your user profile.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [String] :name
        # @option options [String] :email_address
        # @option options [String] :ssh_key
        # @option options [String] :password A password string that conforms to the minimum requirements
        # @option options [String] :password_confirmation A password string that conforms to the minimum requirements
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#user_update_user
        #
        def update_user(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          wrapped_request("put", "/1.0/users/#{identifier}", [200], options)
        end

      end
    end
  end
end
