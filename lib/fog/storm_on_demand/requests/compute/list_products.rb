module Fog
  module Compute
    class StormOnDemand
      class Real
        def list_products(options={})
          request(
            :path => '/Product/list',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
