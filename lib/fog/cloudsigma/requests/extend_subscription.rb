module Fog
  module Compute
    class CloudSigma
      class Real
        def extend_subscription(sub_id, data)
          request(:path => "subscriptions/#{sub_id}/action/",
                  :method => 'POST',
                  :expects => [200, 202],
                  :query => {:do => :extend},
                  :body=>data)
        end
      end

      class Mock
        def extend_subscription(sub_id, data)
        end
      end
    end
  end
end
