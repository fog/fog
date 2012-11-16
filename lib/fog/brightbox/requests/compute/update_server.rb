module Fog
  module Compute
    class Brightbox
      class Real
        # Update some details of the server.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [String] :name Editable label
        # @option options [String] :user_data User defined metadata
        #
        # @return [Hash, nil] The JSON response parsed to a Hash or nil if no options passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_update_server
        #
        def update_server(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          request("put", "/1.0/servers/#{identifier}", [200], options)
        end

      end
    end
  end
end
