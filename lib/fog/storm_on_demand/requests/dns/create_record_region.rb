module Fog
  module DNS
    class StormOnDemand
      class Real

        def create_record_region(options={})
          request(
            :path => '/Network/DNS/Record/Region/create',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
