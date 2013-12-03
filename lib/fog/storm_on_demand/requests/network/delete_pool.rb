module Fog
  module Network
    class StormOnDemand
      class Real

        def delete_pool(options={})
          request(
            :path => '/Network/Pool/delete',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
