module Fog
  module Compute
    class StormOnDemand
      class Real

        def get_product_price(options={})
          request(
            :path => '/Product/price',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
