module Fog
  module Compute
    class Brightbox
      class Real
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [String] :name
        # @option options [String] :description
        # @option options [Array] :allow_access ...
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#database_server_update_database_server
        #
        def update_database_server(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          wrapped_request("put", "/1.0/database_servers/#{identifier}", [200], options)
        end

      end
    end
  end
end
