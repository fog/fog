module Fog
  module Compute
    class Brightbox
      class Real

        # Add a number of servers to a server group
        #
        #  >> Compute[:brightbox].add_servers_server_group "grp-12345", :servers => [{:server => "srv-abcde"}]
        #
        # == Parameters:
        # * identifier (String) - The identifier of the server group to add to
        # * options
        #   * servers (Array) - An Array of Hashes containing {"server" => server_id} for each server to add
        #   [\[{"server" => "srv-abcde"}, {"server" => "srv-fghij"}\]]
        #
        # == Returns:
        #
        # A Ruby hash of the server response
        #
        def add_servers_server_group(identifier, options)
          return nil if identifier.nil? || identifier == ""
          request("post", "/1.0/server_groups/#{identifier}/add_servers", [202], options)
        end

      end
    end
  end
end