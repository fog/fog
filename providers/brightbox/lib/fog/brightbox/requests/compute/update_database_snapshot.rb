module Fog
  module Compute
    class Brightbox
      class Real
        # Update some details of the server.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [String] :name Editable label
        # @option options [String] :description Editable label
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#database_snapshot_update_database_snapshot
        #
        def update_database_snapshot(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          wrapped_request("put", "/1.0/database_snapshots/#{identifier}", [200], options)
        end
      end
    end
  end
end
