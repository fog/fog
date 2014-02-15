module Fog
  module Compute
    class Brightbox
      class Real
        # List database server types.
        #
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#database_type_list_database_types
        #
        def list_database_types
          wrapped_request("get", "/1.0/database_types", [200])
        end

      end
    end
  end
end
