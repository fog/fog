module Fog
  module DNS
    class StormOnDemand
      class Real
        def get_record(options={})
          request(
            :path => '/Network/DNS/Record/details',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
