module Fog
  module DNS
    class StormOnDemand
      class Real

        def update_record(options={})
          request(
            :path => '/Network/DNS/Record/update',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
