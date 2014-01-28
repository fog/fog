module Fog
  module Compute
    class Brightbox
      class Real
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#database_snapshot_list_database_snapshots
        #
        def list_database_snapshots
          wrapped_request("get", "/1.0/database_snapshots", [200])
        end

      end
    end
  end
end
