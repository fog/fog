module Fog
  module Volume
    class OpenStack

      class Real
        def delete_snapshot(snapshot_id)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :path    => "snapshots/#{snapshot_id}"
          )
        end
      end

      class Mock
        def delete_snapshot(snapshot_id)
          response = Excon::Response.new
          if list_snapshots.body['snapshots'].map { |r| r['id'] }.include? snapshot_id
            self.data[:snapshots].delete(snapshot_id)
            response.status = 204
            response
          else
            raise Fog::Volume::OpenStack::NotFound
          end
        end
      end

    end
  end
end