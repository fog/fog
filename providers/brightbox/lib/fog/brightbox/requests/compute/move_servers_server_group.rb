module Fog
  module Compute
    class Brightbox
      class Real
        # Removes a number of server from the server group and adds them to another server group given in parameters.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [Array<Hash>] :servers Array of Hashes containing
        #   +{"server" => server_id}+ for each server to remove
        # @option options [String] :destination ServerGroup to move servers to
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_group_move_servers_server_group
        #
        # @example
        #   options = {
        #     :destination => "grp-67890",
        #     :servers => [
        #       {"server" => "srv-abcde"},
        #       {"server" => "srv-fghij"}
        #     ]
        #   }
        #   Compute[:brightbox].remove_servers_server_group "grp-12345", options
        #
        def move_servers_server_group(identifier, options)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("post", "/1.0/server_groups/#{identifier}/move_servers", [202], options)
        end
      end
    end
  end
end
