module Fog
  module Compute
    class Brightbox
      class Real
        # Add a number of servers to the server group.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [Array<Hash>] :servers Array of Hashes containing `{"server" => server_id}` for each server to add
        #
        # @return [Hash, nil] The JSON response parsed to a Hash or nil if no options passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_group_add_servers_server_group
        #
        # @example
        #    Compute[:brightbox].add_servers_server_group "grp-12345", :servers => [{"server" => "srv-abcde"}, {"server" => "srv-fghij"}]
        #
        def add_servers_server_group(identifier, options)
          return nil if identifier.nil? || identifier == ""
          request("post", "/1.0/server_groups/#{identifier}/add_servers", [202], options)
        end

      end
    end
  end
end
