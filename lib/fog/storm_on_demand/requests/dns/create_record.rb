module Fog
  module DNS
    class StormOnDemand
      class Real

        def create_record(options={})
          request(
            :path => '/Network/DNS/Record/create',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
