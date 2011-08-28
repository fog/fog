module Fog
  module Compute
    class Brightbox
      class Real

        # Remove a number of servers from a server group
        #
        #  >> Compute[:brightbox].remove_servers_server_group "grp-12345", :servers => [{:server => "srv-abcde"}]
        #
        # == Parameters:
        # * identifier (String) - The identifier of the server group to remove from
        # * options (Array) - An Array of Hashes containing {"server" => server_id} for each server to remove
        #   [\[{"server" => "srv-abcde"}, {"server" => "srv-fghij"}\]]
        #
        # == Returns:
        #
        # A Ruby hash of the server response
        #
        def remove_servers_server_group(identifier, options)
          return nil if identifier.nil? || identifier == ""
          request("post", "/1.0/server_groups/#{identifier}/remove_servers", [202], options)
        end

      end
    end
  end
end