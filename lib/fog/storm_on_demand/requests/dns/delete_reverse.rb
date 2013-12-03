module Fog
  module DNS
    class StormOnDemand
      class Real

        def delete_reverse(options={})
          request(
            :path => '/Network/DNS/Reverse/delete',
            :body => Fog::JSON.encode(:params => options)
          )
        end
        
      end
    end
  end
end
