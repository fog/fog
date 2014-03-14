module Fog
  module Compute
    class Brightbox
      class Real
        # Create a new server for the account based on the required disk image.
        #
        # Optionally can setup the type of server, zone to locate it, groups to join and custom metadata.
        #
        # @param [Hash] options
        # @option options [String] :image
        # @option options [String] :name Editable label
        # @option options [String] :server_type
        # @option options [String] :zone Zone in which to create new Server
        # @option options [String] :user_data
        # @option options [Array] :server_groups Array of server groups to add server to
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_create_server
        #
        def create_server(options)
          wrapped_request("post", "/1.0/servers", [202], options)
        end

      end
    end
  end
end
