module Fog
  module Compute
    class CloudSigma
      class Real
        def get_pricing(currency=nil, subscription=false)
          query = {:limit => 0}
          if currency
            query[:currency] = currency
          end
          if subscription
            query[:level] = 0
          end
          request(:path => "pricing/",
                  :method => 'GET',
                  :expects => 200,
                  :query => query)
        end
      end

      class Mock
        def get_pricing(currency=nil, subscription=false)
          mock_get(:pricing,  200)
        end
      end
    end
  end
end
