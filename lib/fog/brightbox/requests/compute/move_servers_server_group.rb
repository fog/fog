module Fog
  module Compute
    class Brightbox
      class Real

        # Moves a number of servers between two server groups
        #
        #  >> Compute[:brightbox].remove_servers_server_group "grp-12345", :destination => "grp-67890", :servers => [{:server => "srv-abcde"}]
        #
        # == Parameters:
        # * identifier - The identifier (String) of the server group to remove from
        # * options (Hash)
        #   * destination (String)- The identifier of the server group to move to
        #   * servers (Array) - Array of Hashes containing {"server" => server_id} for each server to remove
        #   [\[{"server" => "srv-abcde"}, {"server" => "srv-fghij"}\]]
        #
        # == Returns:
        #
        # A Ruby hash of the server response
        #
        def move_servers_server_group(identifier, options)
          return nil if identifier.nil? || identifier == ""
          request("post", "/1.0/server_groups/#{identifier}/move_servers", [202], options)
        end

      end
    end
  end
end