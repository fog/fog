module Fog
  module Compute
    class StormOnDemand
      class Real

        def check_server_attached(options={})
          request(
            :path => '/Network/Private/isAttached',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
