module Fog
  module DNS
    class StormOnDemand
      class Real
        def update_reverse(options={})
          request(
            :path => '/Network/DNS/Reverse/update',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
