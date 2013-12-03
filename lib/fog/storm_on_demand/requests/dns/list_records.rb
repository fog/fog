module Fog
  module DNS
    class StormOnDemand
      class Real

        def list_records(options={})
          request(
            :path => '/Network/DNS/Record/list',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
