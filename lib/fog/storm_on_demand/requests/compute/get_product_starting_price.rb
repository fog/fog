module Fog
  module Compute
    class StormOnDemand
      class Real
        def get_product_starting_price(options={})
          request(
            :path => '/Product/startingPrice',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
