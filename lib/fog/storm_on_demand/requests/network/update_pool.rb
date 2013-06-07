module Fog
  module Network
    class StormOnDemand
      class Real

        def update_pool(options={})
          request(
            :path => '/Network/Pool/update',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
