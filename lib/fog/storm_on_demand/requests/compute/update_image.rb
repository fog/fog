module Fog
  module Compute
    class StormOnDemand
      class Real

        def update_image(options={})
          request(
            :path => '/Storm/Image/update',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
