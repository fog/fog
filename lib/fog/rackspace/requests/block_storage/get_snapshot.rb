module Fog
  module Rackspace
    class BlockStorage
      class Real

        # Retrieves snapshot detail
        # @param [String] snapshot_id
        # @return [Excon::Response] response
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/GET_getSnapshot__v1__tenant_id__snapshots.html
        def get_snapshot(snapshot_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "snapshots/#{snapshot_id}"
          )
        end
      end

      class Mock
        def get_snapshot(snapshot_id)
          snapshot = self.data[:snapshots][snapshot_id]
          if snapshot.nil?
            raise Fog::Rackspace::BlockStorage::NotFound
          else
            response(:body => {"snapshot" => snapshot})
          end
        end
      end
    end
  end
end
