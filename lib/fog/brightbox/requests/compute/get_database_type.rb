module Fog
  module Compute
    class Brightbox
      class Real
        # Get details of the database server type.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#database_type_get_database_type
        #
        def get_database_type(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("get", "/1.0/database_types/#{identifier}", [200])
        end

      end
    end
  end
end
