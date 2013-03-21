module Fog
  module Rackspace
    class BlockStorage
      class Real

        # Retrieves list of snapshots
        # @return [Excon::Response] response
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/GET_getSnapshotsSimple__v1__tenant_id__snapshots.html
        def list_snapshots
          request(
            :expects => [200],
            :method => 'GET',
            :path => 'snapshots'
          )
        end
      end

      class Mock
        def list_snapshots
          snapshots = self.data[:snapshots].values

          response(:body => {"snapshots" => snapshots})
        end
      end
    end
  end
end
