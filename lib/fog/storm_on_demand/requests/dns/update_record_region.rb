module Fog
  module DNS
    class StormOnDemand
      class Real

        def update_record_region(options={})
          request(
            :path => '/Network/DNS/Record/Region/update',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
