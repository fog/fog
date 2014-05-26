module Fog
  module Account
    class StormOnDemand
      class Real
        def create_token(options={})
          request(
            :path => '/Account/Auth/token',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
