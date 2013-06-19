module Fog
  module DNS
    class StormOnDemand
      class Real

        def delete_zone(options={})
          request(
            :path => '/Network/DNS/Zone/delete',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
