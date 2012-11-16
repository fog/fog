module Fog
  module Compute
    class Brightbox
      class Real
        # Update some details of the server group.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [String] :name Editable user label
        # @option options [String] :description Editable user description
        #
        # @return [Hash, nil] The JSON response parsed to a Hash or nil if no options passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#server_group_update_server_group
        #
        def update_server_group(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          request("put", "/1.0/server_groups/#{identifier}", [202], options)
        end

      end
    end
  end
end
