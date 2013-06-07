module Fog
  module Account
    class StormOnDemand
      class Real

        def expire_token(options={})
          request(
            :path => '/Account/Auth/expireToken',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
