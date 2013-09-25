module Fog
  module Compute
    class CloudSigma
      class Real
        def clone_libvolume(vol_id, clone_params={})
          request(:path => "libdrives/#{vol_id}/action/",
                  :method => 'POST',
                  :query => {:do => :clone},
                  :body => clone_params,
                  :expects => [200, 202])
        end
      end

      class Mock
        def clone_libvolume(vol_id, clone_params={})
          volume = self.data[:libvolumes][vol_id].dup
          uuid = self.class.random_uuid
          volume['uuid'] = uuid

          self.data[:volumes][uuid] = volume

          response = Excon::Response.new
          response.status = 200
          response.body = volume

          response
        end
      end

    end
  end
end
