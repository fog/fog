module Fog
  module Compute
    class StormOnDemand
      class Real

        def get_product(options={})
          request(
            :path => '/Product/details',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
