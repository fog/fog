module Fog
  module Compute
    class Brightbox
      class Real
        # @param [Hash] options
        # @option options [String] :name
        # @option options [String] :description
        # @option options [String] :version Database version to request
        # @option options [Array] :allow_access ...
        # @option options [String] :snapshot
        # @option options [String] :zone
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#database_server_create_database_server
        #
        def create_database_server(options)
          wrapped_request("post", "/1.0/database_servers", [202], options)
        end

      end
    end
  end
end
