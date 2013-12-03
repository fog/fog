module Fog
  module Network
    class StormOnDemand
      class Real

        def create_pool(options={})
          request(
            :path => '/Network/Pool/create',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
