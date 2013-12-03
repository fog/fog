module Fog
  module Compute
    class StormOnDemand
      class Real

        def get_product_code(options={})
          request(
            :path => '/Product/getProductCodeFromPath',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
