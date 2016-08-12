module Fog
  module Compute
    class CloudSigma
      class Real
        def clone_snapshot(snap_id, clone_params={})
          request(:path => "snapshots/#{snap_id}/action/",
                  :method => 'POST',
                  :query => {:do => :clone},
                  :body => clone_params,
                  :expects => [200, 202])
        end
      end

      class Mock
        def clone_snapshot(snap_id, clone_params={})
          snapshot = self.data[:snapshots][snap_id].dup
          uuid = self.class.random_uuid
          snapshot['uuid'] = uuid

          self.data[:snapshots][uuid] = snapshot

          response = Excon::Response.new
          response.status = 200
          response.body = snapshot

          response
        end
      end
    end
  end
end
