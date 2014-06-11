module Fog
  module Compute
    class StormOnDemand
      class Real
        def create_image(options={})
          request(
            :path => '/Storm/Image/create',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
