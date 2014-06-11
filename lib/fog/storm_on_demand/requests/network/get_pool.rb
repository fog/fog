module Fog
  module Network
    class StormOnDemand
      class Real
        def get_pool(options={})
          request(
            :path => '/Network/Pool/details',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
